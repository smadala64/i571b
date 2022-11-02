class Recur_Parser:
    def __init__(self, string):
        self.string = string
        self.tempToken = ''
        self.output = []
        self.output = self.getStringBetween(self.string)

    def getStringBetween(self, string):
        string = string.replace(' ', '').replace(',}', '}')
        Brckt = 0
        tempToken = ''
        output = []
        for i in string:
            if i == '{':
                if Brckt > 0:
                    tempToken += i
                Brckt += 1
            elif i == '}':
                Brckt -= 1
                if Brckt == 0:
                    output = self.tokeniseString(tempToken, output)
                else:
                    tempToken += i
            else:
                tempToken += i
        if Brckt != 0:
            raise Exception('Error')
        return output

    def tokeniseString(self, token, output):
        temp = ''
        Brckt = 0
        for i in token:
            if i == '{':
                Brckt += 1
            elif i == '}':
                Brckt -= 1
            if (i == ',' or i == '}') and Brckt == 0:
                if i == '}':
                    temp += i
                if temp:
                    output = self.addToOutput(temp, output)
                temp = ''
            else:
                temp += i
        output = self.addToOutput(temp, output)
        return output

    def addToOutput(self, token, output):
        temp = []
        if token[0] == '{':
            output.append(self.getStringBetween(token))
        elif not '=' in token:
            output.append(int(token))
        else:
            if not '...' in token:
                key, val = token.split('=')
                key = key[1:-1]
                output = output + \
                    [0 for i in range(len(output), int(key))] + [int(val)]
            else:
                keys, val = token.split('=', 1)
                if '{' in val:
                    val = self.getStringBetween(val)
                keys = keys[1:-1].split("...")
                dump = []
                output = output + [0 for i in range(len(output), int(keys[0]))]
                for i in range(int(keys[0]), int(keys[1])+1):
                    output.append(val)
        return output


if __name__ == '__main__':

    print('Input the grammar...\n')
    string = str(input())

    print('Input:', string)
    parsed_string = Recur_Parser(string)
    print('Output:', parsed_string.output)
