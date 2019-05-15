/*******************************************************************/
/*STD    CLPBASE                                                   */
/*EXI    TEXT('Midas SC get start journal receiver')                 */
/*******************************************************************/
/*                                                                 */
/*       Midas - System Control Module                             */
/*                                                                 */
/*       SCC2475 - Check start journal receiver                    */
/*                                                                 */
/*       (c) Finastra International Limited 2012                   */
/*                                                                 */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR965821 *CREATE   Date 10May12              */
/*                                                                 */
/*******************************************************************/
/*                                                                 */
/*       MD046248 - Finastra Rebranding                              */
/*       AR965821 - FDC0050 00001 ends in database error           */
/*                  (Child:AR965823)                               */
/*                                                                 */
/*******************************************************************/
             PGM        PARM(&RETURN)
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETVAR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENDN) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                           Finastra International Limited +
                           2012')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                           CMDLBL(ABNOR))
 
             CHGVAR     VAR(&RETVAR) VALUE('IR00000001')
 RECHK:      CHKOBJ     OBJ(&RETVAR) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&ENDN) VALUE(%SST(&RETVAR 8 3))
               CHGVAR     VAR(&ENDN) VALUE(&ENDN + 1)
               CHGVAR     VAR(%SST(&RETVAR 8 3)) VALUE(&ENDN)
               MONMSG     MSGID(CPF0819) EXEC(DO)
               SNDPGMMSG  MSG('Error in retrieving the start journal +
                          receiver') TOMSGQ(MOPERQ) MSGTYPE(*INFO)
               GOTO       CMDLBL(ABNOR)
               ENDDO
/**/
/** Fail if IR00000001 to IR00000999 is missing */
/**/
             IF         COND(&ENDN > 999) THEN(DO)
               SNDPGMMSG  MSG('Error in retrieving the start journal +
                          receiver') TOMSGQ(MOPERQ) MSGTYPE(*INFO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
               GOTO       CMDLBL(RECHK)
             ENDDO
 
             CHGVAR     VAR(&RETURN) VALUE(&RETVAR)
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGVAR     VAR(&RETURN) VALUE('IR00000001')
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                           Finastra International Limited')
 
             ENDPGM
 
