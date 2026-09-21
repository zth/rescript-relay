const fs=require('fs');
const os=require('os');
const path=require('path');
const {execFile}=require('child_process');
const execFileAsync=require('util').promisify(execFile);
const {buildConversionModules}=require('../scripts/build-conversion-modules');

test('release ESM and CommonJS exports execute the same legacy and prepared conversions',async()=>{
  const directory=fs.mkdtempSync(path.join(os.tmpdir(),'relay-conversion-modules-'));
  try {
    buildConversionModules(directory);
    // Test native ESM, bypassing Jest's dynamic-import-to-require transform.
    const program=`
      import assert from 'node:assert/strict';
      import {pathToFileURL} from 'node:url';
      import {createRequire} from 'node:module';
      const require=createRequire(import.meta.url);
      const esm=await import(pathToFileURL(process.argv[1]));
      const cjs=require(process.argv[2]);
      assert.deepEqual(Object.keys(esm).sort(),Object.keys(cjs).sort());
      const data={items:['1',null],after:null};
      const legacy={__root:{items:{ca:'scalar'}}};
      const plan={version:2,roots:{__root:[{path:['items'],list:1,scalar:'scalar'}]}};
      for(const nullable of [null,undefined]) {
        const expected={items:[1,nullable],after:nullable};
        for(const module of [esm,cjs]) {
          assert.deepEqual(module.traverser(data,legacy,{scalar:Number},nullable),expected);
          assert.deepEqual(module.runConversion(module.prepareConversion(plan,{scalar:Number},nullable),data),expected);
        }
      }
      assert.deepEqual(data,{items:['1',null],after:null});
    `;
    await execFileAsync(process.execPath,['--input-type=module','-e',program,path.join(directory,'utils.mjs'),require.resolve('../src/utils')],{stdio:'pipe'});
  } finally {fs.rmSync(directory,{recursive:true,force:true});}
});
