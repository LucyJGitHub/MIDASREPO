/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MM Initialization Program for CER020')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC00090 - Midas LE Initialisation program for CER020       */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG22611           Date 09Feb09              */
/*                      BUG22159           Date 16Jan09              */
/*                      CER020  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22611 - German Features initialization pgm error         */
/*       BUG22159 - No deliverable date for DLC00070 and LEC00090    */
/*       CER020 - Enhanced Rollover Window: Upgrade FGE089 to        */
/*                Midas Plus                                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&LIB) VALUE(&PREF *CAT 'DMLIB')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***Start*Commitment*Control**/                                                         /*BUG22611*/
 
             IF         COND((&PMODE *EQ '1') *OR (&PMODE *EQ '2')) +
                        THEN(DO)
 
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)  */                                 /*BUG22611*/
/**********  MONMSG     MSGID(CPF8351)               */                                 /*BUG22611*/
 /** Call the take-on rpg */
 
             IF         COND(&PMODE *NE '3') THEN(DO)
             CALL       PGM(LE000090)
             ENDDO
 
 /** If error occur */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/**********  ROLLBACK  */                                                               /*BUG22611*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**********  ELSE       CMD(DO)         */                                              /*BUG22611*/
/**********  COMMIT                     */                                              /*BUG22611*/
/**********  ENDDO                      */                                              /*BUG22611*/
 
/**********  ENDCMTCTL                  */                                              /*BUG22611*/
/**********  MONMSG     MSGID(CPF8355)  */                                 /*BUG22159*/ /*BUG22611*/
 
             ENDDO
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /** Send error message */
 
             SNDPGMMSG  MSG('Program LE000090 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:
             MONMSG     MSGID(CPF2105)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             ENDPGM
