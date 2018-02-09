/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Update Database on Backup Machine')             */
/********************************************************************/
/*                                                                  */
/*        Midas - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1756 - UPDATE DATABASE ON BACKUP MACHINE                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG9619            Date 01Feb06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10May95              */
/*                      S01345               DATE 06NOV91           */
/*                      S01337               DATE 17APR91           */
/*                      E13205               DATE 13/03/89          */
/*                      S01179               DATE 13/09/88          */
/*                      S01127               DATE 02/06/88          */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       S01408  -  Addition of core hook SDC1756MP1                */
/*       S01345  -  JOURNALLING SYSTEM RE-WRITE.                    */
/*       S01337  -  SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES  */
/*                  NOTE - THE FILE REFERENCED IS ACTUALLY IN       */
/*                  THE 'DM' LIBRARY AND HAS THEREFORE              */
/*                  BEEN AMENDED HERE                               */
/*       E13205 (a) Delete JRNEX1.QTEMP before extracting for       * /*E13205*/
/*                  FF journal entries                              * /*E13205*/
/*              (b) Call SDC1722 instead of SDC1751 to apply        * /*E13205*/
/*                  journal entries for non-FF multim files         * /*E13205*/
/*              (c) Call SDC1762 instead of SDC1752 to restore      * /*E13205*/
/*                  data areas                                      * /*E13205*/
/*              (c) Retrieve first journal entry for 'SV' not       * /*E13205*/
/*                  'SC' as indicated.                              * /*E13205*/
/*              (d) Correct call to SDC1748                         * /*E13205*/
/*       S01179  -  AS400 CONVERSION                                */
/*       S01127  -  ADDITIONALLY PROCESS FUTURES/OPTIONS FILES -    */
/*                  INCLUDING MULTIMEMBER FILES                     */
/*                  CHANGE JOURNAL CODE 'SR' TO 'IR'                */
/*                                                                  */
/********************************************************************/
/**/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   Initial processing                                             */
/**/
             DCL        VAR(&SEQN1) TYPE(*DEC) LEN(10)
             DCL        VAR(&SEQN2) TYPE(*DEC) LEN(10)
             DCL        VAR(&FRPNT) TYPE(*DEC) LEN(10)
             DCL        VAR(&TOPNT) TYPE(*DEC) LEN(10)
             DCL        VAR(&RCVNUM) TYPE(*DEC) LEN(3)
             DCL        VAR(&LSTNUM) TYPE(*DEC) LEN(3)
             DCL        VAR(&LSTRCV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&LRCV) TYPE(*CHAR) LEN(8) VALUE('ICRCV   ')
             DCL        VAR(&FF) TYPE(*CHAR) LEN(1)                   /*S01127*/
             DCL        VAR(&BLK) TYPE(*CHAR) LEN(2) VALUE('  ')      /*S01127*/
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)                /*S01127*/
             DCLF       FILE(RCVRYL)
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
/**********  DCLDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/**/
/*   Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Update Database on Backup Machine') +
                          TOMSGQ(MRUNQ)
/**/
/*   Obtain no. of last receiver to be restored from JNSTAT         */
/**/
             RTVDTAARA  DTAARA(JNSTAT *ALL) RTNVAR(&JNSTAT)
             CHGVAR     VAR(&LSTRCV) VALUE(%SST(&JNSTAT 6 3))
             CHGVAR     VAR(&RCVNUM) VALUE(&LSTRCV)
             CHGVAR     VAR(&LSTNUM) VALUE(&RCVNUM - 1)
             CHGVAR     VAR(%SST(&LRCV 6 3)) VALUE(&LSTNUM)
/**/
/****Obtain*sequence*nos.*of*first*'SC'*&*last*'JS'*entries*in*the**/ /*E13205*/
/*   Obtain sequence nos. of first 'SV' & last 'JS' entries in the */ /*E13205*/
/*   journal to give section containing changes to be applied       */
/**/
/*           RTVJRNE    JRN(ICJRN) RCVRNG(ICRCV001 &LRCV) +        */ /*E13205*/
/*                        ENTTYP(SC) RTNSEQNBR(&SEQN1)             */ /*E13205*/
             RTVJRNE    JRN(ICJRN) RCVRNG(ICRCV001 &LRCV) +
                          ENTTYP('SV') RTNSEQNBR(&SEQN1)              /*E13205*/
             RTVJRNE    JRN(ICJRN) RCVRNG(&LRCV ICRCV001) +
                          FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) ENTTYP(JS) RTNSEQNBR(&SEQN2)
/**/
/*  Output journal information into JRNEX1                          */
/**/
                                                                      /*S01127*/
/************DSPJRN*****JRN(ICJRN)*RCVRNG(ICRCV001*&LRCV)*ENTTYP(SR*/ /*S01127*/
             DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 &LRCV) ENTTYP(IR  +
                          ER SV JS AY EJ MR SA) OUTPUT(*OUTFILE)     +
                          OUTFILE(JRNEX1)                             /*S01127*/
                                                                      /*S01127*/
             MONMSG     MSGID(CPF7062)
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
/* CHECK IF FUTURES AND OPTIONS MODULE IS PRESENT */                  /*S01127*/
/**/                                                                  /*S01127*/
             RTVDTAARA  DTAARA(MMOD (50 1)) RTNVAR(&FF)               /*S01127*/
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS PRESENT, ALSO ADD ENTRIES ADDED DURING EOC  *  *S01127*/
/* (THESE HAVE TO BE ADDED USING CPYF, AS THE DSPJRN COMMAND CAN    *  *S01127*/
/* ONLY HAVE 10 ENTTYP ENTRIES AND THERE IS NO *ADD OPTION)         *  *S01127*/
/**/                                                                  /*S01127*/
             IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
/**/
/***********  RCVDTAARA  DTAARA(SDSTAT)                             *  *S01179*/
              RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)               /*S01179*/
/** CHGVAR  VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2) *CAT 'DLIB')     *S01127 S01337*/
              CHGVAR VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2) *CAT 'DMLIB') /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1756MP1                                          */
                                                                      /*S01408*/
              DLTF       FILE(QTEMP/JRNEX1)                           /*E13205*/
              MONMSG     MSGID(CPF2105)                               /*E13205*/
              CRTDUPOBJ  OBJ(JRNEX1) FROMLIB(&LIBR)              +
                          OBJTYPE(*FILE) TOLIB(QTEMP)                 /*S01127*/
              MONMSG     MSGID(CPD2104)                               /*S01127*/
               DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 &LRCV) ENTTYP(IE +
                          SR RC EE) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/JRNEX1)                       /*S01127*/
               MONMSG     MSGID(CPF7062) EXEC(GOTO CMDLBL(ENDFF))     /*S01127*/
               CPYF       FROMFILE(QTEMP/JRNEX1) TOFILE(JRNEX1)     +
                            MBROPT(*ADD) FMTOPT(*NOCHK)               /*S01127*/
 ENDFF:        DLTF       FILE(QTEMP/JRNEX1)                          /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/
             CLRPFM     FILE(RCVRY)
/**/
/*  Call SD1721 to set up recovery areas                           */
/**/
             CALL       PGM(SD1721) PARM(&SEQN1 &SEQN2)
/**/
/*  Search journal for a 'CA' entry. If not found, execute processing       */
/*  to apply journal changes to the database                                */
/**/
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) JRNCDE('U') ENTTYP('CA')
             MONMSG     MSGID(CPF7073) EXEC(DO)
/**/
                SNDPGMMSG  MSG('Applying journal changes') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSGID(MEM0006) MSGF(MIDAS) TOPGMQ(*EXT) +
                             MSGTYPE(*STATUS)
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS IS PRESENT IN THE SYSTEM, SET UP PF/JRNFIL  *  *S01127*/
/* TO CONTAIN ONLY SINGLE MEMBER FILES.                             *  *S01127*/
/* ( FF MULTIMEMBER FILES RECOVERED BY SDC1747 & SDC1748 )          *  *S01127*/
/**/                                                                  /*S01127*/
                IF         COND(&FF *EQ 'Y') THEN(DO)                 /*S01127*/
                    CLRPFM     FILE(JRNFIL)                           /*S01127*/
/*******************CALL       PGM(SD1730) PARM('   ') **/ /*S01127*/ /*S01345*/
                    CALL       PGM(RRC1730)                           /*S01345*/
                ENDDO                                                 /*S01127*/
/**/                                                                  /*S01127*/
/**/
/*  Read file RCVRYL and call SDC1751 to apply journal changes     */
/**/
 READ:          RCVF
                MONMSG     MSGID(CPF0864) EXEC(GOTO CHKFF)            /*S01127*/
/***************MONMSG*****MSGID(CPF0864) EXEC(DO)*******************  *S01127*/
/******************SNDJRNE****JRN(ICJRN)*TYPE('CA')******************  *S01127*/
/******************SNDPGMMSG**MSG('Journal changes applied')*+*******  *S01127*/
/*******************************TOMSGQ(MRUNQ)************************  *S01127*/
/******************SNDPGMMSG**MSGID(MEM0007)*MSGF(MIDAS)*TOPGMQ(*EXT*  *S01127*/
/*******************************MSGTYPE(*STATUS)*********************  *S01127*/
/******************GOTO*******CMDLBL(CLEAR)**************************  *S01127*/
/******************ENDDO*********************************************  *S01127*/
/*              CALL       PGM(SDC1751) PARM(&FRPNT &TOPNT &LRCV)  */ /*E13205*/
                CALL       PGM(SDC1722) PARM(&FRPNT &TOPNT &LRCV)     /*E13205*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS IS PRESENT IN THE SYSTEM, FORWARD RECOVER   *  *S01127*/
/* 'OTC' MEMBER OF MULTIMEMBER FILES BETWEEN THE POINTS             *  *S01127*/
/* IDENTIFIED FOR SINGLE MEMBER FILES                               *  *S01127*/
/**/                                                                  /*S01127*/
             IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
                CALL      PGM(SDC1747) PARM(&BLK &FRPNT &TOPNT &LRCV) /*S01127*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)     /*S01127*/
             ENDDO                                                    /*S01127*/
/**/                                                                  /*S01127*/
                CHGVAR     VAR(%SST(&JNSTAT 137 10)) VALUE(&TOPNT)
/*************  SNDDTAARA  DTAARA(JNSTAT)                           *  *S01179*/
                CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)              /*S01179*/
                GOTO       CMDLBL(READ)
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS IS PRESENT IN THE SYSTEM,                   *  *S01127*/
/* NOW THAT ALL NON FF FILES AND FF SINGLE-MEMBER FILES AND THE     *  *S01127*/
/* 'OTC' MEMBER OF FF MULTI-MEMBER FILES HAVE BEEN FORWARD RECOVERED*  *S01127*/
/* RECOVER ALL MEMBERS OF FF MULTI-MEMBER FILES                     *  *S01127*/
/**/                                                                  /*S01127*/
 CHKFF:      IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
/**/                                                                  /*S01127*/
/* FORWARD RECOVER ALL OTHER MARKET MEMBERS FOR POINTS DETERMINED   *  *S01127*/
/* FOR EACH MARKET INDIVIDUALLY                                     *  *S01127*/
/**/                                                                  /*S01127*/
/*   CALL       PGM(SDC1748) PARM(SEQN1 &SEQN2 &LRCV)   */ /*S01127*/ /*E13205*/
                CALL       PGM(SDC1748) PARM(&SEQN1 &SEQN2 &LRCV)     /*E13205*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)     /*S01127*/
/**/                                                                  /*S01127*/
/* AS ANY MARKET MAY HAVE BEEN RECOVERED TO A POINT WITHIN ITS EOC  *  *S01127*/
/* WHERE IT WAS ACTIVE, SET ANY SUCH MARKET STATUS TO FAILED SO     *  *S01127*/
/* THAT IT CAN BE RESTARTED USING EOC RESTART PROCEDURE             *  *S01127*/
/* AND CLEAR ANY REQUESTED 'HOLDS'                                  *  *S01127*/
/**/                                                                  /*S01127*/
                CALL       PGM(SDC1744)                               /*S01127*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)     /*S01127*/
/**/                                                                  /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**********  SNDJRNE    JRN(ICJRN) TYPE('CA') */                              /*S01127*/ /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('CA') FORCE(*YES)                                /*BUG9619*/
             SNDPGMMSG  MSG('Journal changes applied')               +
                          TOMSGQ(MRUNQ)                               /*S01127*/
             SNDPGMMSG  MSGID(MEM0007) MSGF(MIDAS) TOPGMQ(*EXT)      +
                          MSGTYPE(*STATUS)                            /*S01127*/
                                                                      /*S01127*/
             ENDDO
/**/
/*  Obtain 'recover to' point from JNSTAT & clear RCVRY file                */
/**/
/*LEAR:******RTVDTAARA**DTAARA(JNSTAT *ALL)*RTNVAR(&JNSTAT)*********  *S01127*/
             RTVDTAARA  DTAARA(JNSTAT *ALL) RTNVAR(&JNSTAT)          /*S01127*/
             CHGVAR     VAR(&TOPNT) VALUE(%SST(&JNSTAT 137 10))
             CLRPFM     FILE(RCVRY)
/**/
/*  Call SDC1752 to restore the data areas                           */
/**/
/*           CALL       PGM(SDC1752) PARM(&TOPNT &LRCV)            */ /*E13205*/
             CALL       PGM(SDC1762) PARM(&TOPNT &LRCV)               /*E13205*/
/**/
                        GOTO END
/**/
ABNOR:       SNDPGMMSG  MSG('Update Database on Backup Machine +
                        ENDED ABNORMALLY') TOPGMQ(*EXT)              +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
