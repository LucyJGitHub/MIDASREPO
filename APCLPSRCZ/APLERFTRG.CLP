/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Rate Fix Trigger Program for CLOANCL')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APLERFTRG - Midas LE Rate Fix Trigger Program for CLOANCL   */
/*                                                                   */
/*       (c) Finastra International Limited 2016                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD022769           Date 13Jul16              */
/*                      MD021216           Date 13Jul16              */
/*                      AR925993   *CREATE  Date 13Jul16             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD022769 - Program ended abnormally when entering new loan. */
/*                  Place ENDDO after QSNDDTAQ and DMPCLPGM on ABNOR.*/
/*                - Applied for MD039397.                            */
/*       MD021216 - Program failed to send the data queue message    */
/*                  due to library not found. Update &DTAQ and       */
/*                  &DTAQLIBL even when no advice to print.          */
/*                - Applied for MD039397.                            */
/*       AR925993 - Rollover rate fixing does not produce            */
/*                  confirmation. Trigger program will run if        */
/*                  an update will occur on file CLOANCL.            */
/*                  (Child: AR925994)                                */
/*                - Applied for MD039397.                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2)
 
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PARM2) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&CTR) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(10)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2016')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CTR) VALUE(0)
             CALL       PGM(LE3166) PARM(&CTR)
 
             IF         COND(&CTR > 0) THEN(DO)
/**********  CHGVAR     VAR(&DTAQ) VALUE('APLERTFDQ   ')                    */ /*AR925993 MD021216*/
/**********  CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                       */ /*AR925993 MD021216*/
             CHGVAR     VAR(%SST(&MSGDATA 1 8)) VALUE('LERTCONF')
/**********  ENDDO                                                          */ /*AR925993 MD022769*/
                                                                                        /*MD021216*/
             CHGVAR     VAR(&DTAQ) VALUE('APLERTFDQ   ')                                /*MD021216*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                                   /*MD021216*/
             CALL       PGM(QSNDDTAQ) PARM(&DTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
             ENDDO       /*MD022769*/
                                                                                        /*MD022769*/
            GOTO       CMDLBL(END)
 ABNOR:
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM                                                                   /*MD022769*/
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                           APLERFTRG ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
