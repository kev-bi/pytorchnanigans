from memory import Pointer, UnsafePointer, memset_zero
from random import rand

struct Matrix[dtype: DType](Copyable, Movable, Stringable, Representable, Writable):
    var rows: Int
    var cols: Int
    var data: UnsafePointer[Scalar[dtype]]

    fn __init__(out self, rows: Int, cols: Int):
        print("Matrix.__init__")
        self.rows = rows
        self.cols = cols
        self.data = UnsafePointer[Scalar[dtype]].alloc(self.rows * self.cols)
        print("  self address at ", Pointer.address_of(self).__str__())
    
    fn __copyinit__(out self, other: Matrix[dtype]):
        print("Matrix.__copyinit__")
        print("  other address at ", Pointer.address_of(other).__str__())
        self.cols = other.cols
        self.rows = other.rows
        self.data = UnsafePointer[Scalar[dtype]].alloc(self.rows * self.cols)
        for i in range(self.rows):
            for j in range(self.cols):
                self[i, j] = other[i,j]
        print("  self address at ", Pointer.address_of(self).__str__())

    fn __moveinit__(out self, owned existing: Matrix[dtype]):
        print("Matrix.__moveinit__")
        print("  existing address at ", Pointer.address_of(existing).__str__())
        self.cols = existing.cols
        self.rows = existing.rows
        self.data = existing.data
        print("self address at ", Pointer.address_of(self).__str__())

    fn __del__(owned self):
        print("Matrix.__del__ ")
        print("  self address at ", Pointer.address_of(self).__str__())
        self.data.free()
    
    fn zeros(self):
        """
        Sets all matrix elements to zero.
        """
        memset_zero(self.data, self.rows * self.cols)
    
    fn ones(mut self):
        """
        Sets all matrix elements to one.
        """
        for i in range(self.rows):
            for j in range(self.cols):
                self[i, j] = 1

    fn rand(self):
        """
        Sets all matrix elements to a random value.
        """
        rand[dtype](self.data, self.rows * self.cols)

    fn T(self) -> Matrix[dtype]:
        """
        Returns the transpose of the matrix.
        """
        var transposed = Matrix[dtype](self.cols, self.rows)

        for j in range(self.cols):
            for i in range(self.rows):
                transposed[j, i] =  self[i,j]

        return transposed

    fn to_string(self) -> String:
        """
        Returns a String representation of the matrix.
        """
        var row_str: String
        var matrix_str: String = "[\n"

        for i in range(self.rows):
            row_str = "  [ " + self[i, 0].__str__()
            for j in range(1, self.cols):
                row_str += ", " + self[i, j].__str__()
            row_str += "]\n"
            matrix_str += row_str
        matrix_str += "]"

        return matrix_str

    fn __getitem__(self, i: Int, j: Int) -> Scalar[dtype]:
        return self.load(i, j)

    fn __setitem__(mut self, i: Int, j: Int, val: Scalar[dtype]):
        self.store(i, j, val)

    fn load[nelts: Int = 1](self, j: Int, i: Int) -> SIMD[dtype, nelts]:
        return self.data.load[width=nelts](j * self.cols + i)

    fn store[nelts: Int = 1](self, j: Int, i: Int, val: SIMD[dtype, nelts]):
        self.data.store(j * self.cols + i, val)

    fn write_to[W: Writer](self, mut writer: W) -> None:
        writer.write(self.to_string())

    fn __str__(self) -> String:
        return String.write(self)
    
    fn __repr__(self) -> String:
        return String("Matrix(rows=") + repr(self.rows) \
                + ", cols=" + repr(self.cols) \
                + ", data=" + self.to_string() + ")"
