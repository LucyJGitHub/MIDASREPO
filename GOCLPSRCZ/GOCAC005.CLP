/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Global Update Accounts - end Task Split')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GOCAC005  - Midas GO Global Update Accounts Task Split -    */
/*                   End Task Split                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1097467          Date 17Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP013  *CREATE    Date 19Feb09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1097467B - Expected 15% COB run optimization not met      */
/*       CGP013 - Task split component COB Global Update Accounts    */
/*                - End Task Split                                   */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&CNAM &CSEQ)                            */               /*AR1097467B*/
             PGM                                                                      /*AR1097467B*/
 
/* Declare variables */
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('GOCACTS   ')
/**********  DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)               */               /*AR1097467B*/
/**********  DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)               */               /*AR1097467B*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOURNAL) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)             */               /*AR1097467B*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GOCAC005 - Global Update Accounts - End +
                          Task Split') TOMSGQ(MRUNQ)
 
/* Determine full DMLIB library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DMLIB) VALUE(&SYSID *CAT 'DMLIB')
 
/* Determine full JLIB and DTAQLIB library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'DPLIB')
 
/* Define journal name */
 
             CHGVAR     VAR(&JOURNAL) VALUE('J' *CAT &CNAME)
 
/* Delete main data queue */
 
             DLYJOB     DLY(10)
 
             DLTDTAQ    DTAQ(&DTAQLIB/GOACNTSRV)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/**Retrieve*first*member*description**/                                               /*AR1097467B*/
 
/**********  RTVMBRD    FILE(ACTSDVPD) RTNMBR(&MEMBER)               */               /*AR1097467B*/
 
/**Delete*sub-task*data*queue**/                                                      /*AR1097467B*/
 
/***LOOP:       DLTDTAQ    DTAQ(&DTAQLIB/&MEMBER)                    */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF2105 CPF9801)                       */               /*AR1097467B*/
 
/**Retrieve*next*member*description**/                                                /*AR1097467B*/
 
/**********  RTVMBRD    FILE(ACTSDVPD) MBR(&MEMBER *NEXT) +
                          RTNMBR(&MEMBER)                            */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(REMOVE))     */               /*AR1097467B*/
 
/**Loop*for*all*members*in*driving*file**/                                            /*AR1097467B*/
 
/**********  GOTO       CMDLBL(LOOP)                                 */               /*AR1097467B*/
 
/***REMOVE:                                                          */               /*AR1097467B*/
 
/**Remove*all*members*from*driving*file*and*trailer*file**/                           /*AR1097467B*/
 
/**********  RMVM       FILE(ACTSDVPD) MBR(*ALL)                     */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF7301 CPF7303)                       */               /*AR1097467B*/
 
             GOTO       CMDLBL(END)
 
ABNOR:       SNDPGMMSG  MSG('Program GOCAC005 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
