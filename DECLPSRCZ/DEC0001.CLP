/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DE Projections Extract Controller')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0001 - Projections Extract Controller for CCRM Limits    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL029             Date 01Sep03              */
/*                      CDE005             Date 20Aug02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002             Date 05Dec00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                    . CDE001  *CREATE    Date 12Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       CDE005 - Data Export - Reservation ID                       */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TTYP &EOB)
 
/*/COPY WNCPYSRC,DEC0001INT                                          */
 
             DCL        VAR(&TTYP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&EOB ) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&EXTT) TYPE(*CHAR) LEN( 4) VALUE('*ALL')
/**********  DCL        VAR(&TREF) TYPE(*CHAR) LEN(20) */                                 /*CGL029*/
             DCL        VAR(&TREF) TYPE(*CHAR) LEN(26)                                    /*CGL029*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&EOF) TYPE(*CHAR) LEN(1) VALUE('0')       /*CDE002*/
             DCLF       FILE(MARKTD)                                  /*CDE002*/
             DCL        VAR(&RSRV) TYPE(*CHAR) LEN(10)                /*CDE005*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0001 - Projections Extracts') +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0001MPS                                          */
 
             CHGVAR     VAR(&PGM) VALUE('DEPXC' *CAT &TTYP)
 
             CLRPFM     FILE(DEPTRANPD) MBR(&TTYP)
             CLRPFM     FILE(DEPPOSNPD) MBR(&TTYP)
             CLRPFM     FILE(DEPEVNTPD) MBR(&TTYP)
             CLRPFM     FILE(DEPCASHPD) MBR(&TTYP)
 
             OVRDBF     FILE(DEPTRANPD) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEPPOSNPD) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEPEVNTPD) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEPCASHPD) MBR(&TTYP) SHARE(*NO)
 
             OVRDBF     FILE(DEALS)    SHARE(*NO)
             OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO) +
                          /*CDE002*/
             OVRDBF     FILE(MMDEALLL) SHARE(*NO)
             OVRDBF     FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(CLOAN) TOFILE(CLOAN) SHARE(*NO)
 
             IF         COND(&TTYP *EQ 'OTCC') THEN(DO)               /*CDE002*/
             OVRDBF     FILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(PRICS) MBR(OTC) SHARE(*NO)
             ENDDO                                                    /*CDE002*/
                                                                      /*CDE002*/
             IF         COND(&TTYP *NE 'EXTR') THEN(DO)               /*CDE002*/
                                                                      /*CDE002*/
 /********** CALL       PGM(&PGM) PARM(&RTCD &ERMS &EXTT &EOB &TREF) */ /*CDE005*/
             CALL       PGM(&PGM) PARM(&RTCD &ERMS &EXTT &EOB &TREF +
                          &RSRV)                                      /*CDE005*/
                                                                      /*CDE002*/
             ENDDO                                                    /*CDE002*/
                                                                      /*CDE002*/
             IF         COND(&TTYP *EQ 'EXTR') THEN(DO)               /*CDE002*/
              OVRDBF     FILE(MARKTD) NBRRCDS(1)                      /*CDE002*/
 READ:        RCVF       RCDFMT(*FILE)                                /*CDE002*/
                                                                      /*CDE002*/
              MONMSG     MSGID(CPF0864) EXEC(DO)                      /*CDE002*/
               CHGVAR     VAR(&EOF) VALUE('1')                        /*CDE002*/
              ENDDO                                                   /*CDE002*/
                                                                      /*CDE002*/
              IF         COND(&EOF *EQ '0') THEN(DO)                  /*CDE002*/
               OVRDBF     FILE(TRANS) MBR(&MRKT) SHARE(*NO)           /*CDE002*/
               OVRDBF     FILE(TRSET) MBR(&MRKT) SHARE(*NO)           /*CDE002*/
               OVRDBF     FILE(PRICS) MBR(&MRKT) SHARE(*NO)           /*CDE002*/
/**********    CALL       PGM(&PGM) PARM(&RTCD &ERMS &EXTT &EOB +
                          &TREF)                           /*CDE002*/ /*CDE005*/
               CALL       PGM(&PGM) PARM(&RTCD &ERMS &EXTT &EOB +
                          &TREF &RSRV)                                /*CDE005*/
               GOTO       CMDLBL(READ)                                /*CDE002*/
              ENDDO                                                   /*CDE002*/
                                                                      /*CDE002*/
             ENDDO                                                    /*CDE002*/
 
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
              IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0001 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
              ENDDO
 
              IF         COND(&JOBTYPE = '1') THEN(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
              ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,DEC0001MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0001ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0001 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0001END                                          */
 
             RCLRSC
             RCLRSC     LVL(*CALLER)
 
             ENDPGM
