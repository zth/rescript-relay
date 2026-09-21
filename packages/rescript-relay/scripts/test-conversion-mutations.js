#!/usr/bin/env node
// Targeted behavioral mutation checks, not an exhaustive mutation score.
// Run in isolated temporary modules; never rewrite the working source.
const fs = require('fs');
const os = require('os');
const path = require('path');
const {spawn} = require('child_process');
const root = path.resolve(__dirname,'..');
const source = fs.readFileSync(path.join(root,'src/prepareConversion.js'),'utf8');
const directory = fs.mkdtempSync(path.join(os.tmpdir(),'relay-conversion-mutations-'));
const config = {...require('../jest.config'),rootDir:root,bail:false,collectCoverage:false,
  roots:[path.join(root,'__tests__')],testRegex:'/utils-prepared-tests.js$'};
const faults = [
  ['null handling','value == null ? nullable : isOption(value)','value == null ? value : isOption(value)'],
  ['option markers','isOption(value) ? value : convert(value)','isOption(value) ? convert(value) : convert(value)'],
  ['sparse lists','if (!(i in values)) continue;',''],
  ['callback count','const next = convert(value);','const next = convert(convert(value));'],
  ['source mutation','if (result === undefined) result = { ...value };','if (result === undefined) result = value;'],
  ['shared fragment refs','updatableFragmentRefs: refs','updatableFragmentRefs: { ...refs }'],
  ['scalar boundary','convert = callback(node.scalar);','convert = value => any(callback(node.scalar)(value));'],
  ['union ordering','(children[value.__typename] || any)(union(value))','union((children[value.__typename] || any)(value))'],
  ['union dispatch','children[value.__typename]','children.User'],
  ['list depth','i < depth;','i < Math.min(depth, 1);'],
  ['path boundaries','for (const key of entry.path)','for (const key of [entry.path.join("_")])'],
  ['callback snapshot','return callbacks[name];','return value => callbacks[name](value);'],
  ['opaque metadata','!hasOwn(value, key) || isMetadata(key)','!hasOwn(value, key)'],
];
function run(configuration) {
  const file = path.join(directory,'jest.json');
  fs.writeFileSync(file,JSON.stringify(configuration));
  const report = path.join(directory, 'results.json');
  const log = path.join(directory, 'jest.log');
  fs.rmSync(report, {force:true});
  const fd = fs.openSync(log, 'w');
  return new Promise((resolve,reject) => {
    const child = spawn(process.execPath,[require.resolve('jest/bin/jest'),'--config',file,
      '--runInBand','--no-cache','--json','--outputFile',report],
      {cwd:root,stdio:['ignore',fd,fd],env:{...process.env,FORCE_COLOR:'0',CI:'true'}});
    fs.closeSync(fd);
    const timer = setTimeout(() => child.kill('SIGKILL'), 30000);
    child.on('error', error => {clearTimeout(timer);reject(error);});
    child.on('close', (status,signal) => {
      clearTimeout(timer);
      const output = fs.readFileSync(log,'utf8');
      if (signal || !fs.existsSync(report)) return reject(new Error('Jest did not complete: '+signal+'\n'+output));
      resolve({status,output,report:JSON.parse(fs.readFileSync(report,'utf8'))});
    });
  });
}
async function main() {
try {
  const control = await run(config);
  if (control.status !== 0 || control.report.numPassedTests === 0) throw new Error('Unmodified control failed:\n'+control.output);
  for (const [name,before,after] of faults) {
    if (!source.includes(before)) throw new Error('Mutation no longer matches source: '+name);
    const mutant = path.join(directory,'prepareConversion.js');
    fs.writeFileSync(mutant,source.replace(before,after));
    const result = await run({...config,moduleNameMapper:{'^\\./prepareConversion$':mutant}});
    if (result.status === 0 || result.report.numFailedTests === 0) {
      throw new Error('Mutation survived or failed without a behavioral assertion: '+name+'\n'+result.output);
    }
    process.stdout.write('Detected: '+name+'\n');
  }
  process.stdout.write(faults.length+' / '+faults.length+' targeted mutations detected.\n');
} finally {fs.rmSync(directory,{recursive:true,force:true});}

}
main().catch(error=>{console.error(error);process.exitCode=1;});
