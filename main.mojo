from mlib import Matrix

alias f32 = DType.float32

fn main() raises:
    var m = Matrix[f32](2, 3)
    print("String: {!s}\nRepresentation: {!r}\n".format(m, m))

    m.ones()
    print("String: {!s}\n".format(m))
    
    m.rand()
    print("String: {!s}\n".format(m))

    m_t = m.T()
    print("String: {!s}\n".format(m_t))
