import * as math from 'mathjs'

translateBy = (vec, translation) =>
    return math.add(vec, translation)


rotateBy = (vec, rotations) =>
    # map from degrees to radians
    [ xRotate, yRotate, zRotate ] = rotations.map((each) => (each * Math.PI) /180)
    newVec = vec
    # perform the x axis rotation
    newVec = math.multiply(
        [
            [ math.cos(xRotate), -math.sin(xRotate), 0 ],
            [ math.sin(xRotate),  math.cos(xRotate), 0 ],
            [ 0                ,  0                , 1 ],
        ],
        newVec
    )
    # perform the y axis rotation
    newVec = math.multiply(
        [
            [ math.cos(xRotate), 0, -math.sin(xRotate) ],
            [ 0                , 1,  0                 ],
            [ math.sin(xRotate), 0,  math.cos(xRotate) ],
        ],
        newVec
    )
    # perform the z axis rotation
    newVec = math.multiply(
        [
            [ 1, 0                ,  0                 ],
            [ 0, math.cos(xRotate), -math.sin(xRotate) ],
            [ 0, math.sin(xRotate),  math.cos(xRotate) ],
        ],
        newVec
    )
    return newVec