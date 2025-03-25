// Auto-generated. Do not edit!

// (in-package serial_communication.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class ultrasonic_data {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.l = null;
      this.r = null;
      this.b = null;
    }
    else {
      if (initObj.hasOwnProperty('l')) {
        this.l = initObj.l
      }
      else {
        this.l = 0;
      }
      if (initObj.hasOwnProperty('r')) {
        this.r = initObj.r
      }
      else {
        this.r = 0;
      }
      if (initObj.hasOwnProperty('b')) {
        this.b = initObj.b
      }
      else {
        this.b = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type ultrasonic_data
    // Serialize message field [l]
    bufferOffset = _serializer.int16(obj.l, buffer, bufferOffset);
    // Serialize message field [r]
    bufferOffset = _serializer.int16(obj.r, buffer, bufferOffset);
    // Serialize message field [b]
    bufferOffset = _serializer.int16(obj.b, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type ultrasonic_data
    let len;
    let data = new ultrasonic_data(null);
    // Deserialize message field [l]
    data.l = _deserializer.int16(buffer, bufferOffset);
    // Deserialize message field [r]
    data.r = _deserializer.int16(buffer, bufferOffset);
    // Deserialize message field [b]
    data.b = _deserializer.int16(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 6;
  }

  static datatype() {
    // Returns string type for a message object
    return 'serial_communication/ultrasonic_data';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'b84b3d698239ad2fd054a4286e165219';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int16 l
    int16 r
    int16 b
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new ultrasonic_data(null);
    if (msg.l !== undefined) {
      resolved.l = msg.l;
    }
    else {
      resolved.l = 0
    }

    if (msg.r !== undefined) {
      resolved.r = msg.r;
    }
    else {
      resolved.r = 0
    }

    if (msg.b !== undefined) {
      resolved.b = msg.b;
    }
    else {
      resolved.b = 0
    }

    return resolved;
    }
};

module.exports = ultrasonic_data;
