// Auto-generated. Do not edit!

// (in-package project1_solution.msg)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');

//-----------------------------------------------------------

class TwoInts {
  constructor() {
    this.a = 0;
    this.b = 0;
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type TwoInts
    // Serialize message field [a]
    bufferInfo = _serializer.int16(obj.a, bufferInfo);
    // Serialize message field [b]
    bufferInfo = _serializer.int16(obj.b, bufferInfo);
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type TwoInts
    let tmp;
    let len;
    let data = new TwoInts();
    // Deserialize message field [a]
    tmp = _deserializer.int16(buffer);
    data.a = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [b]
    tmp = _deserializer.int16(buffer);
    data.b = tmp.data;
    buffer = tmp.buffer;
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a message object
    return 'project1_solution/TwoInts';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'e01e889cb1a7965611513515df5899bf';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int16 a
    int16 b
    `;
  }

};

module.exports = TwoInts;
