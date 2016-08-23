/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Global Update Accounts - start Task Split')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GOCAC001  - Midas GO Global Update Accounts   - Task Split  */
/*                   Server (Start Task Split)                       */
/*                                                                   */
/*       (c) Misys Banking Systems Ltd. 2009                         */
/*                                                                   */
/*       Last Amend No. AR1097467B         Date 17Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGP013  *Create    Date 18Feb09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1097467B - Expected 15% COB run optimization not met      */
/*       CGP013 - Task split component COB Global Update Accounts    */
/*                (Start Task Split)                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare file and variables */
 
             DCLF       FILE(CBCMPNLC)
 
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)             */               /*AR1097467B*/
/**********  DCL        VAR(&NAME1) TYPE(*CHAR) LEN(5) VALUE('ACTSD')*/               /*AR1097467B*/
/**********  DCL        VAR(&NAME2_C) TYPE(*CHAR) LEN(5)             */               /*AR1097467B*/
/**********  DCL        VAR(&NAME2_N) TYPE(*DEC) LEN(5 0) VALUE(01000)*/              /*AR1097467B*/
             DCL        VAR(&TSK#) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) VALUE('GOCACTS')
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WKDHSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DELRECNO) TYPE(*DEC) LEN(10 0)                           /*AR1097467B*/
             DCL        VAR(&CURRECNO) TYPE(*DEC) LEN(10 0)                           /*AR1097467B*/
             DCL        VAR(&TOTREC) TYPE(*DEC) LEN(10 0)                             /*AR1097467B*/
             DCL        VAR(&NOREC) TYPE(*DEC) LEN(10 0)                              /*AR1097467B*/
             DCL        VAR(&NOREC@) TYPE(*CHAR) LEN(10)                              /*AR1097467B*/
 
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GOCAC001 - - Midas GO Global Update +
                          Accounts - Start Task Split') TOMSGQ(MRUNQ)
 
/* Determine full JLIB and DTAQLIB library name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'DPLIB')
 
/**Clear*index*file**/                                                                /*AR1097467B*/
 
/**********  CLRPFM     FILE(ACTSIXPD)                               */               /*AR1097467B*/
 
/**Remove*all*members*from*driving*file*and*trailer*file**/                           /*AR1097467B*/
 
/**********  RMVM       FILE(ACTSDVPD) MBR(*ALL)                     */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF7301 CPF7303)                       */               /*AR1097467B*/
 
/* Create main data queue */
 
             CHKOBJ     OBJ(&DTAQLIB/GOACNTSRV) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAQ +
                          DTAQ(&DTAQLIB/GOACNTSRV) MAXLEN(50))
             CALL       PGM(QCLRDTAQ) PARM(GOACNTSRV '*LIBL')
             MONMSG     MSGID(CPF9801)
 
/* Retrieve number of sub-tasks */
 
 CHAIN:      RCVF
             CHGVAR     VAR(&WKDHSEQ) VALUE(&DHCSEQ)
             IF         COND((&DHCOTT *NE &CNAME) *OR (&WKDHSEQ *NE +
                          &CSEQ)) THEN(DO)
             GOTO       CMDLBL(CHAIN)
             ENDDO
 
             RTVMBRD    FILE(ACCNTAB) NBRCURRCD(&CURRECNO) +
                        NBRDLTRCD(&DELRECNO)                                          /*AR1097467B*/
             CHGVAR     VAR(&TOTREC) VALUE(&CURRECNO + &DELRECNO)                     /*AR1097467B*/
             CHGVAR     VAR(&NOREC) VALUE((&TOTREC / &DHTSNO) + 1)                    /*AR1097467B*/
             CHGVAR     VAR(&NOREC@) VALUE(&NOREC)                                    /*AR1097467B*/
             RTVMBRD    FILE(ACTSIXPD) NBRCURRCD(&CURRECNO)                           /*AR1097467B*/
             IF         COND(&CURRECNO *EQ 0) THEN(DO)                                /*AR1097467B*/
               SCRUNSQL   SQL('INSERT INTO ACTSIXPD (NORE) VALUES(' +
                            *CAT &NOREC@ *CAT ')')                                    /*AR1097467B*/
             ENDDO                                                                    /*AR1097467B*/
             ELSE       DO                                                            /*AR1097467B*/
               SCRUNSQL   SQL('UPDATE ACTSIXPD SET NORE = ' *CAT +
                            &NOREC@)                                                  /*AR1097467B*/
             ENDDO                                                                    /*AR1097467B*/
                                                                                      /*AR1097467B*/
             GOTO       END                                                           /*AR1097467B*/
                                                                                      /*AR1097467B*/
/**Create*member*and*data*queue(clear*if*needed)*for*1st*task**/                      /*AR1097467B*/
/**********  CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                     */               /*AR1097467B*/
/**********  CHGVAR     VAR(&MEMBER) VALUE(&NAME1 *CAT &CSEQA)       */               /*AR1097467B*/
/**********  ADDPFM     FILE(ACTSDVPD) MBR(&MEMBER)                  */               /*AR1097467B*/
/**********  CHKOBJ     OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ)         */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                      */               /*AR1097467B*/
/**********     CRTDTAQ    DTAQ(&DTAQLIB/&MEMBER) MAXLEN(50)         */               /*AR1097467B*/
/**********     RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER) */               /*AR1097467B*/
/**********     CHGOBJOWN  OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ) +
                             NEWOWN(&OWNER)                          */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/
/**********  CALL       PGM(QCLRDTAQ) PARM(&MEMBER &DTAQLIB)         */               /*AR1097467B*/
 
/**Create*member*and*data*queue(clear*if*needed)*for*2nd*and*following*tasks*/        /*AR1097467B*/
/**********  CHGVAR     VAR(&TSK#) VALUE(2)                          */
/**LOOP:       IF         COND(&TSK# *GT &DHTSNO) THEN(GOTO CMDLBL(END)) */
 
/**Create*member*name*based*on*Seq*#*and*Task*#**/                                    /*AR1097467B*/
/**********  CHGVAR     VAR(&WKDHSEQ) VALUE(&DHCSEQ)                 */               /*AR1097467B*/
/**********  CHGVAR     VAR(&NAME2_N) VALUE(01000)                   */               /*AR1097467B*/
/**********  CHGVAR     VAR(&NAME2_N) VALUE((&NAME2_N * &WKDHSEQ) + &WKDHSEQ + &TSK# - 2) */
/**********  CHGVAR     VAR(&NAME2_C) VALUE(&NAME2_N)                */               /*AR1097467B*/
/**********  CHGVAR     VAR(&MEMBER) VALUE(&NAME1 *CAT &NAME2_C)     */               /*AR1097467B*/
/**********  ADDPFM     FILE(ACTSDVPD) MBR(&MEMBER)                  */               /*AR1097467B*/
 
/**Create*data*queue*if*it*doesn't*already*exist*and*set*authorities.**/              /*AR1097467B*/
/**********  CHKOBJ     OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ)         */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                      */               /*AR1097467B*/
/**********     CRTDTAQ    DTAQ(&DTAQLIB/&MEMBER) MAXLEN(50)         */               /*AR1097467B*/
/**********     RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER) */               /*AR1097467B*/
/**********     CHGOBJOWN  OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ) +
                             NEWOWN(&OWNER)                          */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/
/**********  CALL       PGM(QCLRDTAQ) PARM(&MEMBER &DTAQLIB)         */               /*AR1097467B*/
 
/**********  CHGVAR     VAR(&TSK#) VALUE(&TSK# + 1)                  */               /*AR1097467B*/
/**********  GOTO       CMDLBL(LOOP)                                 */               /*AR1097467B*/
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCAC001 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
