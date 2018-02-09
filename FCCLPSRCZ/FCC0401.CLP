/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Controlling pgm for report distribution')    */
    /*****************************************************************/
    /*                                                               */
    /*   Midas - Report Control Facility Module                      */
    /*                                                               */
    /*   FCC0401 - CONTROLLING PROGRAM FOR REPORT DISTRIBUTION       */
    /*                                                               */
    /*   (c) Finastra International Limited 2001                     */
    /*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*                  CPK009             Date 09Aug99              */
    /*                  101205             Date 05Apr97              */
    /*                  076417             DATE 01MAR95              */
    /*                  S01495             DATE 01OCT94              */
    /*                  E38772             DATE 24APR92              */
    /*                  LN1157             DATE 15MAY91              */
    /*                  LN1051             DATE 30NOV90              */
    /*                  LN1007             DATE 26NOV90              */
    /*                  LN0381             DATE 26JUL90              */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
/*       MD046248 - Finastra Rebranding                              */
    /*  CPK016 - Externalise STRCMTCTL code for ease of later        */
    /*           upgrade.                                            */
    /*  CCB009 - Journal files throughout close of business          */
    /*  CPK009 - Packaging for DBA3 release. STRCMTCTL values set    */
    /*           to CMTSCOPE(*JOB).                                  */
    /*  101205 - Retry allocation of FC0100 data area.               */
    /*  076417 - Allocate FCSNOSPD before ending journalling.        */
    /*           Locking problem with FCC01.                         */
    /*  S01495 - COB enhancements.                                   */
    /*  E38772 - STRJRNPF processing moved from this program to      */
    /*           CBCMON to avoid locking problems between FCC0401    */
    /*           and the first COB Components.                       */
    /*  LN1157 - CALL FC0100 WITH PARAMETER &PHASE.                  */
    /*  LN1051 - ENSURE THAT JOURNALLING STARTS CORRECTLY IN COB     */
    /*           AND ONLY STARTS FOR THOSE FILES REQUIRED            */
    /*  LN1007 - REMOVE PHASE PARAMETER FROM CALL TO FC0100 - COB    */
    /*           AND INPUT-CYCLE PROCESSING THE SAME.                */
    /*  LN0381 - FILE  MAAWRKPD  REPLACED BY MAEXPTPD                */
    /*                 FOR MICROFICHE ARCHIVING                      */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM WILL CALL FC0100 - REPORT DISTRIBUTION PROGRAM  */
    /*  WHILST RUNNING IN BATCH                                      */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
             PGM        PARM(&PHASE)
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2 0) VALUE(0)      /*101205*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
/* */                                                                 /*101205*/
/** Retry allocating FC0100 dtaara if first attempt fails.  After  */ /*101205*/
/** 60 attempts, end loop and send appropriate message so as not   */ /*101205*/
/** to cause an endless loop.                                      */ /*101205*/
/* */                                                                 /*101205*/
/************ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(1)        */ /*101205*/
RETRY:       ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(10)          /*101205*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                       /*101205*/
               CHGVAR   VAR(&COUNT) VALUE(&COUNT + 1)                 /*101205*/
               IF       COND(&COUNT *GE 60) THEN(GOTO CMDLBL(ABNOR))  /*101205*/
               ELSE     CMD(GOTO CMDLBL(RETRY))                       /*101205*/
             ENDDO                                                    /*101205*/
 
/********IF ****** COND(&PHASE *EQ 'C') THEN(STRJRNPF +      *LN0381*/
/*****************  FILE(FCSFNOPD MAARCDPD MAAWRKPD MAMWRKPD +LN0381*/
/*****************  MAOWRKPD) JRN(CBJRN) IMAGES(*BOTH) +     *LN0381*/
/*****************   OMTJRNE(*OPNCLO))                       *LN0381*/
 
/**IF*********COND(&PHASE *EQ 'C') THEN(STRJRNPF +                     *LN1051*/
/***************FILE(FCSFNOPD MAARCDPD MAEXPTPD MAMWRKPD +             *LN1051*/
/***************MAOWRKPD) JRN(CBJRN) IMAGES(*BOTH) +                   *LN1051*/
/***************OMTJRNE(*OPNCLO))                            *LN0381*  *LN1051*/
                                                                      /*LN1051*/
/**IF*PHASE*IS*'C'*-*BEING*SUBMITTED*IN*CLOSE*OF*BUSINESS*-*  /*LN1051**E38772*/
/**JOURNAL*THE*FILES*MONITORING*TO*CHECK*IF*FILES*ALREADY*JOUR/*LN1051**E38772*/
                                                                      /*LN1051*/
/************IF         COND(&PHASE *EQ 'C') +
/*****************THEN(DO)                                    /*LN1051**E38772*/
/*****************STRJRNPF   FILE(FCSFNOPD) JRN(CBJRN) IMAGES(*BOTH) +
/*****************        OMTJRNE(*OPNCLO)                    /*LN1051**E38772*/
/*****************MONMSG     MSGID(CPF7030)                   /*LN1051**E38772*/
/*****************STRJRNPF   FILE(MAARCDPD) JRN(CBJRN) IMAGES(*BOTH) +
/*****************        OMTJRNE(*OPNCLO)                    /*LN1051**E38772*/
/*****************MONMSG     MSGID(CPF7030)                   /*LN1051**E38772*/
/*****************STRJRNPF   FILE(MAEXPTPD) JRN(CBJRN) IMAGES(*BOTH) +
/*****************        OMTJRNE(*OPNCLO)                    /*LN1051**E38772*/
/*****************MONMSG     MSGID(CPF7030)                   /*LN1051**E38772*/
/*****************STRJRNPF   FILE(MAMWRKPD) JRN(CBJRN) IMAGES(*BOTH) +
/*****************        OMTJRNE(*OPNCLO)                    /*LN1051**E38772*/
/*****************MONMSG     MSGID(CPF7030)                   /*LN1051**E38772*/
/*****************STRJRNPF   FILE(MAOWRKPD) JRN(CBJRN) IMAGES(*BOTH) +
/*****************        OMTJRNE(*OPNCLO)                    /*LN1051**E38772*/
/*****************MONMSG     MSGID(CPF7030)                   /*LN1051**E38772*/
/*****************ENDDO                                       /*LN1051**E38772*/
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) + */               /*CPK009*/  /*CPK016*/
/**********               CMTSCOPE(*JOB)                     */                           /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
 
 /***********CALL       PGM(FC0100) PARM(&PHASE)                        LN1007*/
 /***********CALL       PGM(FC0100)                              *LN1007LN1157*/
             CALL       PGM(FC0100) PARM(&PHASE)                      /*LN1157*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                            TOMSGQ(MOPERQ)
                  GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('FCC0401 - Report Distribution program +
                          terminated abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
/*END:*******DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                */ /*S01495*/
/************MONMSG     MSGID(CPF0000 MCH0000)                     */ /*S01495*/
/************IF         COND(&PHASE *EQ 'C') THEN(DO)              */ /*S01495*/
 END:        IF         COND(&PHASE *EQ 'C') THEN(DO)                 /*S01495*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/*******ENDJRNPF * FILE(FCSFNOPD MAARCDPD MAAWRKPD MAMWRKPD + LN0381*/
/*****************   MAOWRKPD)                              /*LN0381*/
 
                  ALCOBJ     OBJ((FCSFNOPD *FILE *EXCL))              /*076417*/
        ENDJRNPF   FILE(FCSFNOPD MAARCDPD MAEXPTPD MAMWRKPD +
                    MAOWRKPD)                               /*LN0381*/
 
                  MONMSG     MSGID(CPF0000 MCH0000)
                  DLCOBJ     OBJ((FCSFNOPD *FILE *EXCL))              /*076417*/
             ENDDO                                                    /*CCB009*/
             ENDDO
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                   /*S01495*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01495*/
             ENDPGM
