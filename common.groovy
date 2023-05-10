def cloudPlatformVersion() {
    return '23.2.2.0'
}

def test() {
    node {
        echo 'test'
    }
}
return this