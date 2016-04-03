################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Please refer to the README for information about making permanent changes.  #
################################################################################

module CZMQ
  module FFI
    
    # generic type-free hash container (simple)
    class Zhash
      class DestroyedError < RuntimeError; end
      
      # Boilerplate for self pointer, initializer, and finalizer
      class << self
        alias :__new :new
      end
      def initialize ptr, finalize=true
        @ptr = ptr
        if @ptr.null?
          @ptr = nil # Remove null pointers so we don't have to test for them.
        elsif finalize
          @finalizer = self.class.send :create_finalizer_for, @ptr
          ObjectSpace.define_finalizer self, @finalizer
        end
      end
      def self.create_finalizer_for ptr
        Proc.new do
          ptr_ptr = ::FFI::MemoryPointer.new :pointer
          ptr_ptr.write_pointer ptr
          ::CZMQ::FFI.zhash_destroy ptr_ptr
        end
      end
      def null?
        !@ptr or ptr.null?
      end
      # Return internal pointer
      def __ptr
        raise DestroyedError unless @ptr
        @ptr
      end
      # Nullify internal pointer and return pointer pointer
      def __ptr_give_ref
        raise DestroyedError unless @ptr
        ptr_ptr = ::FFI::MemoryPointer.new :pointer
        ptr_ptr.write_pointer @ptr
        ObjectSpace.undefine_finalizer self if @finalizer
        @finalizer = nil
        @ptr = nil
        ptr_ptr
      end
      
      # Create a new callback of the following type:
      # Callback function for zhash_freefn method
      #     typedef void (zhash_free_fn) (
      #         void *data);              
      #
      # WARNING: If your Ruby code doesn't retain a reference to the
      #   FFI::Function object after passing it to a C function call,
      #   it may be garbage collected while C still holds the pointer,
      #   potentially resulting in a segmentation fault.
      def self.free_fn
        ::FFI::Function.new :void, [:pointer], blocking: true do |data|
          yield data
        end
      end
      
      # Create a new callback of the following type:
      # DEPRECATED as clumsy -- use zhash_first/_next instead
      #     typedef int (zhash_foreach_fn) (                 
      #         const char *key, void *item, void *argument);
      #
      # WARNING: If your Ruby code doesn't retain a reference to the
      #   FFI::Function object after passing it to a C function call,
      #   it may be garbage collected while C still holds the pointer,
      #   potentially resulting in a segmentation fault.
      def self.foreach_fn
        ::FFI::Function.new :int, [:string, :pointer, :pointer], blocking: true do |key, item, argument|
          yield key, item, argument
        end
      end
      
      # Create a new, empty hash container
      def self.new
        ptr = ::CZMQ::FFI.zhash_new
        
        __new ptr
      end
      
      # Destroy a hash container and all items in it
      def destroy
        return unless @ptr
        self_p = __ptr_give_ref
        result = ::CZMQ::FFI.zhash_destroy self_p
        result
      end
      
      # Insert item into hash table with specified key and item.               
      # If key is already present returns -1 and leaves existing item unchanged
      # Returns 0 on success.                                                  
      def insert key, item
        raise DestroyedError unless @ptr
        key = String(key)
        result = ::CZMQ::FFI.zhash_insert @ptr, key, item
        result
      end
      
      # Update item into hash table with specified key and item.            
      # If key is already present, destroys old item and inserts new one.   
      # Use free_fn method to ensure deallocator is properly called on item.
      def update key, item
        raise DestroyedError unless @ptr
        key = String(key)
        result = ::CZMQ::FFI.zhash_update @ptr, key, item
        result
      end
      
      # Remove an item specified by key from the hash table. If there was no such
      # item, this function does nothing.                                        
      def delete key
        raise DestroyedError unless @ptr
        key = String(key)
        result = ::CZMQ::FFI.zhash_delete @ptr, key
        result
      end
      
      # Return the item at the specified key, or null
      def lookup key
        raise DestroyedError unless @ptr
        key = String(key)
        result = ::CZMQ::FFI.zhash_lookup @ptr, key
        result
      end
      
      # Reindexes an item from an old key to a new key. If there was no such
      # item, does nothing. Returns 0 if successful, else -1.               
      def rename old_key, new_key
        raise DestroyedError unless @ptr
        old_key = String(old_key)
        new_key = String(new_key)
        result = ::CZMQ::FFI.zhash_rename @ptr, old_key, new_key
        result
      end
      
      # Set a free function for the specified hash table item. When the item is
      # destroyed, the free function, if any, is called on that item.          
      # Use this when hash items are dynamically allocated, to ensure that     
      # you don't have memory leaks. You can pass 'free' or NULL as a free_fn. 
      # Returns the item, or NULL if there is no such item.                    
      def freefn key, free_fn
        raise DestroyedError unless @ptr
        key = String(key)
        result = ::CZMQ::FFI.zhash_freefn @ptr, key, free_fn
        result
      end
      
      # Return the number of keys/items in the hash table
      def size
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_size @ptr
        result
      end
      
      # Make copy of hash table; if supplied table is null, returns null.    
      # Does not copy items themselves. Rebuilds new table so may be slow on 
      # very large tables. NOTE: only works with item values that are strings
      # since there's no other way to know how to duplicate the item value.  
      def dup
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_dup @ptr
        result = Zhash.__new result, true
        result
      end
      
      # Return keys for items in table
      def keys
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_keys @ptr
        result = Zlist.__new result, true
        result
      end
      
      # Simple iterator; returns first item in hash table, in no given order, 
      # or NULL if the table is empty. This method is simpler to use than the 
      # foreach() method, which is deprecated. To access the key for this item
      # use zhash_cursor(). NOTE: do NOT modify the table while iterating.    
      def first
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_first @ptr
        result
      end
      
      # Simple iterator; returns next item in hash table, in no given order, 
      # or NULL if the last item was already returned. Use this together with
      # zhash_first() to process all items in a hash table. If you need the  
      # items in sorted order, use zhash_keys() and then zlist_sort(). To    
      # access the key for this item use zhash_cursor(). NOTE: do NOT modify 
      # the table while iterating.                                           
      def next
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_next @ptr
        result
      end
      
      # After a successful first/next method, returns the key for the item that
      # was returned. This is a constant string that you may not modify or     
      # deallocate, and which lasts as long as the item in the hash. After an  
      # unsuccessful first/next, returns NULL.                                 
      def cursor
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_cursor @ptr
        result
      end
      
      # Add a comment to hash table before saving to disk. You can add as many   
      # comment lines as you like. These comment lines are discarded when loading
      # the file. If you use a null format, all comments are deleted.            
      def comment format, result
        raise DestroyedError unless @ptr
        format = String(format)
        result = ::CZMQ::FFI.zhash_comment @ptr, format, result
        result
      end
      
      # Serialize hash table to a binary frame that can be sent in a message.
      # The packed format is compatible with the 'dictionary' type defined in
      # http://rfc.zeromq.org/spec:35/FILEMQ, and implemented by zproto:     
      #                                                                      
      #    ; A list of name/value pairs                                      
      #    dictionary      = dict-count *( dict-name dict-value )            
      #    dict-count      = number-4                                        
      #    dict-value      = longstr                                         
      #    dict-name       = string                                          
      #                                                                      
      #    ; Strings are always length + text contents                       
      #    longstr         = number-4 *VCHAR                                 
      #    string          = number-1 *VCHAR                                 
      #                                                                      
      #    ; Numbers are unsigned integers in network byte order             
      #    number-1        = 1OCTET                                          
      #    number-4        = 4OCTET                                          
      #                                                                      
      # Comments are not included in the packed data. Item values MUST be    
      # strings.                                                             
      def pack
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_pack @ptr
        result = Zframe.__new result, true
        result
      end
      
      # Unpack binary frame into a new hash table. Packed data must follow format
      # defined by zhash_pack. Hash table is set to autofree. An empty frame     
      # unpacks to an empty hash table.                                          
      def self.unpack frame
        frame = frame.__ptr if frame
        result = ::CZMQ::FFI.zhash_unpack frame
        result = Zhash.__new result, true
        result
      end
      
      # Save hash table to a text file in name=value format. Hash values must be
      # printable strings; keys may not contain '=' character. Returns 0 if OK, 
      # else -1 if a file error occurred.                                       
      def save filename
        raise DestroyedError unless @ptr
        filename = String(filename)
        result = ::CZMQ::FFI.zhash_save @ptr, filename
        result
      end
      
      # Load hash table from a text file in name=value format; hash table must 
      # already exist. Hash values must printable strings; keys may not contain
      # '=' character. Returns 0 if OK, else -1 if a file was not readable.    
      def load filename
        raise DestroyedError unless @ptr
        filename = String(filename)
        result = ::CZMQ::FFI.zhash_load @ptr, filename
        result
      end
      
      # When a hash table was loaded from a file by zhash_load, this method will
      # reload the file if it has been modified since, and is "stable", i.e. not
      # still changing. Returns 0 if OK, -1 if there was an error reloading the 
      # file.                                                                   
      def refresh
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_refresh @ptr
        result
      end
      
      # Set hash for automatic value destruction
      def autofree
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_autofree @ptr
        result
      end
      
      # DEPRECATED as clumsy -- use zhash_first/_next instead                  
      # Apply function to each item in the hash table. Items are iterated in no
      # defined order. Stops if callback function returns non-zero and returns 
      # final return code from callback function (zero = success).             
      # Callback function for zhash_foreach method                             
      def foreach callback, argument
        raise DestroyedError unless @ptr
        result = ::CZMQ::FFI.zhash_foreach @ptr, callback, argument
        result
      end
      
      # Self test of this class
      def self.test verbose
        verbose = Integer(verbose)
        result = ::CZMQ::FFI.zhash_test verbose
        result
      end
    end
    
  end
end

################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Please refer to the README for information about making permanent changes.  #
################################################################################
