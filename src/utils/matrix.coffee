math = require('mathjs')
THREE = require('three')
Matrix = THREE.Matrix4

module.exports =
    print: (matrix) => 
        [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] = matrix.elements
        console.log [a,b,c,d]
        console.log [e,f,g,h]
        console.log [i,j,k,l]
        console.log [m,n,o,p]
    
    multiply2: (matrix1, matrix2) =>
        m1Copy = (new Matrix()).set(...matrix1.elements)
        m2Copy = (new Matrix()).set(...matrix2.elements)
        return m1Copy.multiply(m2Copy)

    multiply: (...args) =>
        output = new Matrix()
        while args.length
            output = module.exports.multiply2(args.pop(), output.transpose())
        return output

    rotationMatrix: (x,y,z) =>
        new Matrix().set(...module.exports.rotationMatrixFor([x,y,z]).flat()) 

    transpose: (matrix) =>
        [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] = matrix.elements
        newMatrix = new Matrix()
        newMatrix.set(a,e,i,m,b,f,j,n,c,g,k,o,d,h,l,p)
        return newMatrix
    
    translationMatrix: (x,y,z) =>
        return module.exports.transpose( (new Matrix()).makeTranslation(x,y,z))
    
    
    translateBy: (vec, translation) =>
        return math.add(vec, translation)

    rotationMatrixFor: (rotations) =>
        # map from degrees to radians
        [ xRotate, yRotate, zRotate ] = rotations.map((each) => (each * Math.PI) /180)
        newVec = [
            [1,0,0,0],
            [0,1,0,0],
            [0,0,1,0],
            [0,0,0,1],
        ]
        # perform the x axis rotation
        newVec = math.multiply(
            [
                [ 1, 0                ,  0                , 0 ],
                [ 0, math.cos(xRotate), -math.sin(xRotate), 0 ],
                [ 0, math.sin(xRotate),  math.cos(xRotate), 0 ],
                [ 0                ,  0                , 0, 1 ],
            ],
            newVec
        )
        # perform the y axis rotation
        newVec = math.multiply(
            [
                [ math.cos(yRotate), 0, -math.sin(yRotate), 0 ],
                [ 0                , 1,  0                , 0 ],
                [ math.sin(yRotate), 0,  math.cos(yRotate), 0 ],
                [ 0                ,  0                , 0, 1 ],
            ],
            newVec
        )
        # perform the z axis rotation
        newVec = math.multiply(
            [
                [ math.cos(zRotate), -math.sin(zRotate), 0, 0 ],
                [ math.sin(zRotate),  math.cos(zRotate), 0, 0 ],
                [ 0                ,  0                , 1, 0 ],
                [ 0                ,  0                , 0, 1 ],
            ],
            newVec
        )
        return newVec

    rotateBy: (vec, rotations) =>
        # map from degrees to radians
        [ xRotate, yRotate, zRotate ] = rotations.map((each) => (each * Math.PI) /180)
        newVec = vec
        # perform the x axis rotation
        newVec = math.multiply(
            [
                [ 1, 0                ,  0                , 0 ],
                [ 0, math.cos(xRotate), -math.sin(xRotate), 0 ],
                [ 0, math.sin(xRotate),  math.cos(xRotate), 0 ],
                [ 0                ,  0                , 0, 1 ],
            ],
            newVec
        )
        # perform the y axis rotation
        newVec = math.multiply(
            [
                [ math.cos(yRotate), 0, -math.sin(yRotate), 0 ],
                [ 0                , 1,  0                , 0 ],
                [ math.sin(yRotate), 0,  math.cos(yRotate), 0 ],
                [ 0                ,  0                , 0, 1 ],
            ],
            newVec
        )
        # perform the z axis rotation
        newVec = math.multiply(
            [
                [ math.cos(zRotate), -math.sin(zRotate), 0, 0 ],
                [ math.sin(zRotate),  math.cos(zRotate), 0, 0 ],
                [ 0                ,  0                , 1, 0 ],
                [ 0                ,  0                , 0, 1 ],
            ],
            newVec
        )
        return newVec