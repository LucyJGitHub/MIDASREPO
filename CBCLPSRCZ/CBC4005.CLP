/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call File Copy')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4005 - Midas CB Call File Copy                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2012           */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 20Mar12              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of business Scheduler Enhancement            */
/*                Upgrade IPL089                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FL &FF &TL &TF &AR &R)

             DCL        VAR(&FL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AR) TYPE(*CHAR) LEN(1)

             DCL        VAR(&R) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&R) VALUE(' ')

             CHKOBJ     OBJ(&FL/&FF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             GOTO       CMDLBL(END)
             ENDDO

             CHKOBJ     OBJ(&TL/&TF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CPYF       FROMFILE(&FL/&FF) TOFILE(&TL/&TF) +
                          MBROPT(*ADD) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&AR *EQ 'A') THEN(DO)
             CPYF       FROMFILE(&FL/&FF) TOFILE(&TL/&TF) +
                          MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&AR *EQ 'R') THEN(DO)
             CPYF       FROMFILE(&FL/&FF) TOFILE(&TL/&TF) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(END)
             ENDDO

 END:        ENDPGM
