/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Teller sign on & input control')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4130 - Teller Sign On                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. TDA035             Date 01Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      096490             Date 28Nov95              */
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       TDA035 - RTS Signon changes for MidasPlus.                  */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001 - Retail Teller System.                              */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                          /*TDA035*/
             PGM        PARM(&PRTCD &PWEBUSR)                                             /*TDA035*/
 
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTSDTA)  TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&CHEKSWS) TYPE(*CHAR) LEN(8) VALUE(' ')
             DCL        VAR(&TLID)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&MBR)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTCD)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&PRTCD)   TYPE(*CHAR) LEN(7) VALUE(' ')                       /*TDA035*/
             DCL        VAR(&PWEBUSR) TYPE(*CHAR) LEN(1)                                  /*TDA035*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(80)                                 /*TDA035*/
             DCL        VAR(&PTLID)   TYPE(*CHAR) LEN(3)  VALUE(' ')                      /*TDA035*/
             DCL        VAR(&PTLIX)   TYPE(*CHAR) LEN(3)  VALUE(' ')                      /*TDA035*/
 
 
/**  Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
 
/**  Send info to message queue */                                                        /*TDA035*/
                                                                                          /*TDA035*/
             SNDPGMMSG  MSG('REC4130 - Prompt for Teller SignON') +
                          TOMSGQ(MRUNQ)                                                   /*TDA035*/
 
/**  Initialise job switches  */
 
             CHGJOB     SWS(00000000)
 
 
/**  Create RTS job data area  */
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CRTDTAARA  DTAARA(QTEMP/RTSDTA) TYPE(*CHAR) LEN(256) +
                          TEXT('RTS Teller Transaction Job Dataarea')
             MONMSG     MSGID(CPF1023)
             IF         COND(&PWEBUSR *EQ 'N') THEN(DO)                                   /*TDA035*/
             CHGDTAARA  DTAARA(QTEMP/RTSDTA) VALUE(' ')
             ENDDO                                                                        /*TDA035*/
             RTVDTAARA  DTAARA(QTEMP/RTSDTA (1 3)) RTNVAR(&PTLIX)                         /*TDA035*/
 
 
/**  Teller identifier prompt  */
 
/**********  CALL       PGM(RE4130) */                                                    /*TDA035*/
             CALL       PGM(RE4130) PARM(&PWEBUSR &PTLID)                                 /*TDA035*/
 
             IF         COND(%SWITCH(XXXXX1XX) *OR %SWITCH(XXXXXX1X) +
                          *OR %SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
             IF         COND(&PTLID *EQ '   ') THEN(GOTO +
                          CMDLBL(ENDPGM))                                                 /*TDA035*/
                                                                                          /*TDA035*/
/**  Sign off the current teller and sign on to new Teller-ID       */                    /*TDA035*/
                                                                                          /*TDA035*/
             IF         COND((&PWEBUSR *EQ 'Y') *AND (&PTLID *NE +
                          '   ')) THEN(DO)                                                /*TDA035*/
                                                                                          /*TDA035*/
                IF         COND(&PTLIX *NE '   ') THEN(DO)                                /*TDA035*/
                CALL       PGM(REC004152) PARM(&PRTCD &PTLIX)                             /*TDA035*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                              CMDLBL(ABNORMAL))                                           /*TDA035*/
                                                                                          /*TDA035*/
                CALL       PGM(REC004134) PARM(&PRTCD 'OFF' &PTLIX)                       /*TDA035*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                               CMDLBL(ABNORMAL))                                          /*TDA035*/
                CALL       PGM(REC004151) PARM(&PRTCD &PTLID)                             /*TDA035*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                              CMDLBL(ABNORMAL))                                           /*TDA035*/
                ENDDO                                                                     /*TDA035*/
                                                                                          /*TDA035*/
/**  Setup the dataarea RTSDTA and TTRNTM2 based from the Teller-ID */                    /*TDA035*/
                                                                                          /*TDA035*/
             CALL       PGM(REC004134) PARM(&PRTCD 'ON ' &PTLID)                          /*TDA035*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*TDA035*/
             ENDDO                                                                        /*TDA035*/
 
/**  If teller sign on successful?  */
 
             RTVDTAARA  DTAARA(QTEMP/RTSDTA) RTNVAR(&RTSDTA)
 
             IF         COND(%SST(&RTSDTA 1 3) *EQ '   ') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
 
/**  Setup member name  */
 
             RTVDTAARA  DTAARA(QTEMP/RTSDTA (1 3)) RTNVAR(&TLID)
/************CHGVAR*****VAR(&MBR) VALUE('T'****&TLID)                 */ /*BG18886*/
             CHGVAR     VAR(&MBR) VALUE('T' *CAT &TLID)                  /*BG18886*/
 
             CHGVAR     VAR(&MESSAGE) VALUE('REC4130 - The +
                          Teller-ID' *BCAT &TLID *BCAT 'has signed +
                          on successfully.')                                              /*TDA035*/
             SNDPGMMSG  MSG(&MESSAGE) TOMSGQ(MRUNQ)                                       /*TDA035*/
 
/**  Perform file overrides  */
 
             OVRDBF     FILE(CHQDPPD)  SHARE(*YES) SEQONLY(*NO)
 
             OVRDBF     FILE(RSACMTPD) SHARE(*YES) SEQONLY(*NO)
 
             OVRDBF     FILE(TTRANPD) MBR(&MBR) SECURE(*YES) +
                          SHARE(*YES) SEQONLY(*NO)
 
             OVRDBF     FILE(TTRANL1) MBR(&MBR) SECURE(*YES) +
                          SHARE(*YES) SEQONLY(*NO)
 
             OVRDBF     FILE(TTRANPT) MBR(&MBR) SECURE(*YES) +
                          SHARE(*YES) SEQONLY(*NO)
 
 
             OVRDBF     FILE(TTNARPD) SECURE(*YES) SHARE(*YES) +
                          SEQONLY(*NO)
 
             IF         COND(&PWEBUSR *NE 'Y') THEN(DO)                                   /*TDA035*/
             OVRDSPF    FILE(RE4110DF) WAITRCD(%SST(&RTSDTA 85 5))
             ENDDO                                                                        /*TDA035*/
 
 
 
/**  Rebuild access path  */
 
             OPNDBF     FILE(TTRANL1) OPTION(*ALL) MBR(&MBR)
             CLOF       OPNID(TTRANL1)
 
/**  End program if a web user  */                                                        /*TDA035*/
                                                                                          /*TDA035*/
             IF         COND(&PWEBUSR *EQ 'Y') THEN(GOTO CMDLBL(ENDPGM))                  /*TDA035*/
 
/**  Teller menu display  */
 
             CALL       PGM(RE4110)
 
 
/**  Check job status  */
 
             RTVJOBA    SWS(&CHEKSWS)
             DLTOVR     FILE(*ALL)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
 
             IF         COND(&LDA *NE ' ') THEN(GOTO CMDLBL(ABNORMAL))
 
 
/**  Teller sign off  */
 
/**********  CALL       PGM(RE4131) */                                                    /*TDA035*/
             CALL       PGM(RE4131) PARM(&PWEBUSR &PTLID)                                 /*TDA035*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**********  ELSE       CMD(GOTO CMDLBL(ENDPGM)) */                                       /*TDA035*/
                                                                                          /*TDA035*/
             CHGVAR     VAR(&MESSAGE) VALUE('REC4130 - The Teller-ID' +
                          *BCAT &TLID *BCAT 'has signed off.')                            /*TDA035*/
             SNDPGMMSG  MSG(&MESSAGE) TOMSGQ(MRUNQ)                                       /*TDA035*/
             GOTO ENDPGM                                                                  /*TDA035*/
 
 
ABNORMAL:
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&PRTCD) VALUE('*ABNOR')                                       /*TDA035*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ)
             DMPCLPGM                                                                     /*TDA035*/
             ENDDO
 
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
             CHGVAR     VAR(&PRTCD) VALUE('*ERROR')                                       /*TDA035*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/************CHGVAR*****VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 1 3)****+
                          %SUBSTRING(&LDA 11 30))                                     */ /*BG18886*/
             CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 1 3) *CAT +
                          %SUBSTRING(&LDA 11 30))                                        /*BG18886*/
             SNDPGMMSG  MSGID(USR0014) MSGF(RTSMSGF) MSGDTA(&MSGDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/**********  CALL       PGM(RE4131) */                                                    /*TDA035*/
             CALL       PGM(RE4131) PARM(&PWEBUSR &PTLID)                                 /*TDA035*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ABNORMAL))               /*TDA035*/
 
ERROR:
             CHGVAR     VAR(&MSGDTA) VALUE('Transaction failed. +
                          Re-input necessary      ')
             SNDPGMMSG  MSG(&MSGDTA) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
