/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL LE, FT, RE & NT transactions extract ctl')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0002 - LE, FT, RE & NT Transactions Extract Control      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CCM003             Date 01Feb01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Jul99              */
/*                      095456             DATE 06NOV95              */
/*                      CCM002             DATE 04SEP95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CCM003 - Midas/City Dealer Customer Lending interface.      */
/*                Download of Cashflows from Midas to City Dealer.   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       095456 - This program is not ending correctly for Journal   */
/*                Image types 'XJ' and 'XE'.                         */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI)       */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JSEQN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NJRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*CCM003*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*CCM003*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CCM003')  /*CCM003*/
             DCL        VAR(&CCM003) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CCM003*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CCM003*/
/*/COPY WNCPYSRC,DLC0002001                                          */
             DCLF       FILE(DLCDJNPD)
/**/
/*    Global monitor message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*/COPY WNCPYSRC,DLC0002004                                          */
/**/
/*    Receive job attributes                                         */
             RTVJOBA    JOB(&JOBNAME) USER(&USER) NBR(&JOBNO)
/**/
/*    Create data area LDA                                           */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
/*    Amend DTAARA/DLCDSTAT with job details                         */
             CHGDTAARA  DTAARA(DLCDSTAT (1 27)) VALUE('Y' *CAT +
                          &JOBNAME *CAT &USER *CAT &JOBNO)
/**/
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(ABNOR))
/**/
/*    Main Processing                                                */
             CHGJOB     SWS(XXXXXX00)
/**/
/*    Start commitment control                                       */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG MSGID(CPF8351)
/**/
/*    Open database file PF/DLCDJNPD                                 */
             OPNDBF     FILE(DLCDJNPD) OPTION(*INP)
             RCVF
             CHGVAR     VAR(&JSEQN) VALUE(&JOSEQN + 1)
             CHGVAR     VAR(&NJRCV) VALUE(&JNRCN)
/**/
             CLOF       OPNID(DLCDJNPD)
             OVRDBF     FILE(DLCDJNPD) SHARE(*NO)
/**/
/*    Receive journal entry                                        */
/*    Include SDBANKPD for 'XJ' and 'XE' entries.                  */ /*95456*/
/* RCVJ:**   RCVJRNE    JRN(ICJRN) EXITPGM(DL0002) FILE((CLOANCL) +*/ /*95456*/
/*********                (LOAMSDK) (FCLTYFM) (LEFEED) (RSACMTPD))+*/ /*95456*/
/*********                RCVRNG(&NJRCV *CURRENT) FROMENT(&JSEQN) +*/ /*95456*/
/*********                JRNCDE(R U) ENTTYP(PT UP UB BR UR DR XJ +*/ /*95456*/
/*********                XE) DELAY(30)                            */ /*95456*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CCM003*/
             IF         COND(&RTCD *EQ '       ') +
                          THEN(CHGVAR VAR(&CCM003) VALUE('Y'))        /*CCM003*/
             IF         COND(&CCM003 *NE 'Y') +
                          THEN(DO)                                    /*CCM003*/
/*/COPY WNCPYSRC,DLC0002002                                          */
RCVJ:        RCVJRNE    JRN(ICJRN) EXITPGM(DL0002) FILE((CLOANCL) +
                          (LOAMSDK) (FCLTYFM) (LEFEED) (RSACMTPD) +
                          (SDBANKPD))                             +
                          RCVRNG(&NJRCV *CURRENT) FROMENT(&JSEQN) +
                          JRNCDE(R U) ENTTYP(PT UP UB BR UR DR XJ +
                          XE) DELAY(30)                               /*95456*/
/*/COPY WNCPYSRC,DLC0002005                                          */
             MONMSG     MSGID(CPF9803) EXEC(DO)
                DLYJOB     DLY(30)
                GOTO RCVJ
             ENDDO
/*/COPY WNCPYSRC,DLC0002006                                          */
/**/
             IF         COND(%SWITCH(XXXXX100)) THEN(DO)
                CALL       DLC0003 PARM(&JSEQN &NJRCV)
                CHGVAR  VAR(&JSEQN) VALUE(&JSEQN + 1)
                GOTO RCVJ
             ENDDO
/**/
             ENDDO                                                    /*CCM003*/
             ELSE       CMD(DO)                                       /*CCM003*/
 
 /* If CCM003 is switched on then call exit program DL0012 for feature *CCM003*/
 /* CCM003.                                                            *CCM003*/
 
 /* Note - DL0012 will then call DL0011 for feature CCM003 if entry is *CCM003*/
 /* NOT from a Customer Lending file.                                  *CCM003*/
 
             IF         COND(&CCM003 *EQ 'Y') +
                          THEN(DO)                                    /*CCM003*/
 RCVJ2:      RCVJRNE    JRN(ICJRN) EXITPGM(DL0012) FILE((CLOANCL) +
                          (LOAMSDK) (DEALSDB) (NTRANDD) (OTPAYDD) +
                          (INPAYDD) (SDBANKPD) (FCLTYFM))         +
                          RCVRNG(&NJRCV *CURRENT) FROMENT(&JSEQN) +
                          JRNCDE(R U) ENTTYP(PT UP UB BR UR DR XJ +
                          XE) DELAY(30)                               /*CCM003*/
             MONMSG     MSGID(CPF9803) EXEC(DO)                       /*CCM003*/
                DLYJOB     DLY(30)                                    /*CCM003*/
                GOTO RCVJ2                                            /*CCM003*/
             ENDDO                                                    /*CCM003*/
             ENDDO                                                    /*CCM003*/
 
/**/                                                                  /*CCM003*/
             IF         COND(%SWITCH(XXXXX100)) THEN(DO)              /*CCM003*/
                CALL       DLC0003 PARM(&JSEQN &NJRCV)                /*CCM003*/
                CHGVAR  VAR(&JSEQN) VALUE(&JSEQN + 1)                 /*CCM003*/
                GOTO RCVJ2                                            /*CCM003*/
             ENDDO                                                    /*CCM003*/
                                                                      /*CCM003*/
             ENDDO                                                    /*CCM003*/
/*/COPY WNCPYSRC,DLC0002003                                          */
/*    Database error processing                                      */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                ENDCMTCTL
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/*/COPY WNCPYSRC,DLC0002007                                          */
             GOTO       CMDLBL(END)
/**/
 /*   Abnormal termination - batch job                               */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Citydealer LE, FT, RE & NT Transactions +
                          Extract ENDED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*********** CHGDTAARA  DTAARA(DLCDSTAT (1 1)) VALUE('N') **********/ /*95456*/
/*                                                                   */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGDTAARA  DTAARA(DLCDSTAT (1 1)) VALUE('N')             /*95456*/
             ENDPGM
