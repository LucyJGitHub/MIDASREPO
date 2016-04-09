/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC I/C init. interface')                        */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC01 - SET UP RCF FILES FOR START OF DAY                    */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND NO.076417            DATE 01MAR95            */
    /*       PREV AMEND NO.079455            DATE 23NOV94            */
    /*                     E30569            DATE 06NOV91            */
    /*                     S01343            DATE 15AUG91            */
    /*                     LN1034            DATE 27NOV90            */
    /*                     LN0381            DATE 24JUL90            */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  076417  - FCSNOSPD is locked by RCFMONITOR job doing ENDJRNPF*/
    /*            This program should try to allocate it before CPYF */
    /*  079455  - DO NOT CLEAR RCF FILES UNTIL RCF MONITOR HAS       */
    /*            SHUT DOWN                                          */
    /*  E30569  - RESET VALUE OF REPSEQ IN THIS PROGRAM INSTEAD OF   */
    /*            IN SCC01.                                          */
    /*  S01343  - SC/RR/SD MODULE RENAME PROJECT.                    */
    /*            - SCC01 RENAMED FROM SDC01                         */
    /*  LN1034  - REMOVE CALL TO FC0010 AND MOVE TO SCC01            */
    /*            TO SET UP PERIODIC REPORTING DATES PROPERLY        */
    /*  LN0381 - FILE  MACARCPD  REPLACED BY MAEXPTPD                */
    /*           and ARCHIVE Audit added (MA0630)                    */
    /*           for MICROFICHE ARCHIVING                            */
    /*****************************************************************/
    /*                                                               */
    /***THIS*PROGRAM*CALLS*RPG*PROG*FC0010.*PARAMETER*PASSED            LN1034*/
    /***IS*THE*SEQUENCE*NUMBER*(HELD IN A DATA AREA).*******            LN1034*/
    /*                                                               */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/************DCL        VAR(&REPCON) TYPE(*DEC) LEN(5 0) VALUE(1)       LN1034*/
/************DCL        VAR(&REPSEQ) TYPE(*CHAR) LEN(5)                 LN1034*/
             DCL        VAR(&REPCON) TYPE(*DEC) LEN(5 0) VALUE(1)     /*E30569*/
             DCL        VAR(&REPSEQ) TYPE(*CHAR) LEN(5)               /*E30569*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2 0)               /*079455*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
     dcl    &rtcd       *char    7  (' ')                   /*LN0381*/
     dcl    &optn       *char    7  ('*FIRST ')             /*LN0381*/
     dcl    &fmt        *char  200                          /*LN0381*/
     dcl    &fiche      *char    1                          /*LN0381*/
     dcl    &optdk      *char    1                          /*LN0381*/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*  Loop until RCF Monitor has shut down                              /*079455*/
                                                                      /*079455*/
FC0100:                                                               /*079455*/
             ALCOBJ     OBJ((*LIBL/FC0100 *DTAARA *EXCL)) WAIT(0)     /*079455*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                       /*079455*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*079455*/
               IF         COND(&COUNT *GE 30) THEN(DO)
               SNDPGMMSG  MSG('R.C.F Monitor has not terminated ') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*079455*/
               GOTO       CMDLBL(ABNOR)                               /*079455*/
               ENDDO                                                  /*079455*/
               ELSE       CMD(DO)                                     /*079455*/
               DLYJOB     DLY(60)                                     /*079455*/
               GOTO       CMDLBL(FC0100)                              /*079455*/
               ENDDO                                                  /*079455*/
             ENDDO                                                    /*079455*/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                   /*079455*/
                                                                      /*079455*/
             RTVDTAARA  DTAARA(FCC01) RTNVAR(&STATUS)
 
/*     Microfich Module active = (&FMT 54) is 'Y'           *LN0381*/
/*     Optical Disk Module active = (&FMT 85) is 'Y'        *LN0381*/
                                                           /*LN0381*/
     call   AOMMODR0 parm(&RTCD &OPTN &FMT)                /*LN0381*/
/*     Database error handling                              *LN0381*/
     IF     cond(&RTCD *ne '       ') then(DO)             /*LN0381*/
            sndpgmmsg  msg('Error on access to ICD file +
                      AOMMODPD') TOMSGQ(MOPERQ)            /*LN0381*/
            goto ABNOR                                     /*LN0381*/
     ENDDO                                                 /*LN0381*/
                                                           /*LN0381*/
     chgvar &FICHE  (%SST(&FMT 54 1))                      /*LN0381*/
     chgvar &OPTDK  (%SST(&FMT 85 1))                      /*LN0381*/
 
    /*                                                              */
    /* IF PROCESSING HAS BEEN COMPLETED, RETURN                     */
    /*                                                              */
             IF         COND(&STATUS *EQ 'H') THEN(GOTO CMDLBL(THEEND))
 
    /*                                                              */
    /* COPY RECORDS FROM TODAY'S REPORT REQUESTS TO YESTERDAY'S     */
    /* REPORT REQUESTS IF INPUT CYCLE, CLOSE                        */
    /* OF BUSINESS AND PERIODIC FIELDS ARE NOT SET TO 'N'           */
    /* AND THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ ' ') THEN(DO)
                  CPYF       FROMFILE(FCRREQPD) TOFILE(FCYREQPD) +
                               MBROPT(*REPLACE) INCREL((*IF D5IPCY *NE +
                               'N') (*OR D5COBR *NE 'N') (*OR D5PDFL *NE +
                               'N')) FMTOPT(*NOCHK)
    /*                                                              */
    /* IF FROMFILE EMPTY CLEAR TOFILE                               */
    /*                                                              */
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(FCYREQPD))
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(A)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
    /*                                                              */
    /* COPY ALL RECORDS FROM TODAY'S SPOOL FILE NUMBERS TO          */
    /* YESTERDAY'S SPOOL FILE NUMBERS                               */
    /* IF  THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ 'A') THEN(DO)
                  ALCOBJ     OBJ((FCSFNOPD *FILE *EXCL))              /*076417*/
                  CPYF       FROMFILE(FCSFNOPD) TOFILE(FCYFNOPD) +
                               MBROPT(*REPLACE) FMTOPT(*NOCHK)
    /*                                                              */
    /* IF FROMFILE EMPTY CLEAR TOFILE                               */
    /*                                                              */
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(FCYFNOPD))
                  DLCOBJ     OBJ((FCSFNOPD *FILE *EXCL))              /*076417*/
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(B)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
 
/*                                                           *LN0381*/
/*     MICROFICHE PROCESSING - to be performed ONLY,         *LN0381*/
/*      IF either M-Fiche, or Opt-Disk modules are active    *LN0381*/
/*     Else - set STATUS to 'G'                              *LN0381*/
/*                                                           *LN0381*/
 
     IF  ((&FICHE *ne 'Y') *and +
          (&OPTDK *ne 'Y') *and +
          (&STATUS *gt 'A') *and +
          (&STATUS *lt 'G')) +
     THEN(DO)                                               /*LN0381*/
          chgvar   &STATUS   ('G')                          /*LN0381*/
          goto     CLEAR                                    /*LN0381*/
     ENDDO                                                  /*LN0381*/
 
 
    /*                                                              */
    /* COPY ALL RECORDS FROM TODAY'S ARCHIVING CONTENTS DAILY       */
    /* YESTERDAY'S ARCHIVING                                        */
    /* IF  THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ 'B') THEN(DO)
                  CPYF       FROMFILE(MAARCDPD) TOFILE(MAARCYPD) +
                               MBROPT(*REPLACE) FMTOPT(*NOCHK)
    /*                                                              */
    /* IF FROMFILE EMPTY CLEAR TOFILE                               */
    /*                                                              */
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(MAARCYPD))
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(C)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
 
    /*                                                              */
    /* COPY ALL RECORDS FROM TODAY'S MICROFICHE WORK FILE TO        */
    /* YESTERDAY'S                                                  */
    /* IF  THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ 'C') THEN(DO)
                  CPYF       FROMFILE(MAMWRKPD) TOFILE(MAMWKYPD) +
                               MBROPT(*REPLACE) FMTOPT(*NOCHK)
    /*                                                              */
    /* IF FROMFILE EMPTY CLEAR TOFILE                               */
    /*                                                              */
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(MAMWKYPD))
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(D)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
    /*                                                              */
    /* COPY ALL RECORDS FROM TODAY'S OPTICAL DISK WORK FILE         */
    /* YESTERDAY'S                                                  */
    /* IF  THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ 'D') THEN(DO)
                  CPYF       FROMFILE(MAOWRKPD) TOFILE(MAOWKYPD) +
                               MBROPT(*REPLACE) FMTOPT(*NOCHK)
    /*                                                              */
    /* IF FROMFILE EMPTY CLEAR TOFILE                               */
    /*                                                              */
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(MAOWKYPD))
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(E)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
 
    /*                                                              */
    /* COPY ALL RECORDS FROM TODAY'S COLLATION WORK FILE            */
    /* YESTERDAY'S                                                  */
    /* IF  THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ 'E') THEN(DO)
 
/************CPYF ***** FROMFILE(MACARCPD) TOFILE(MACARYPD) +*LN0381*/
/**********************   MBROPT(*REPLACE) FMTOPT(*NOCHK)    *LN0381*/
             cpyf       MAEXPTPD   MAEXPYPD +
                          mbropt(*REPLACE) fmtopt(*NOCHK)   /*LN0381*/
    /*                                                              */
    /* IF FROMFILE EMPTY CLEAR TOFILE                               */
    /*                                                              */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MAEXPYPD))                   /*LN0381*/
/*************************FILE(MACARYPD))                   /*LN0381*/
 
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(F)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
 
    /*                                                              */
    /* COPY ALL RECORDS FROM TODAY'S ARCHIVE WORK FILE              */
    /* YESTERDAY'S                                                  */
    /* IF  THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ 'F') THEN(DO)
                  CPYF       FROMFILE(MAAWRKPD) TOFILE(MAAWKYPD) +
                               MBROPT(*REPLACE) FMTOPT(*NOCHK)
    /*                                                              */
    /* IF FROMFILE EMPTY CLEAR TOFILE                               */
    /*                                                              */
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(MAAWKYPD))
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(G)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
 
/*                                                          /*LN0381*/
/* End of Archiving Files' processing                       /*LN0381*/
/*                                                          /*LN0381*/
 
CLEAR:                                                      /*LN0381*/
 
    /*                                                              */
    /* CLEAR TODAY'S FILES                                          */
    /* IF  THIS HAS NOT ALREADY TAKEN PLACE                         */
    /*                                                              */
             IF         COND(&STATUS *EQ 'G') THEN(DO)
                  CLRPFM     FILE(FCRREQPD)
                  CLRPFM     FILE(FCSFNOPD)
                  CLRPFM     FILE(MAARCDPD)
                  CLRPFM     FILE(MAMWRKPD)
                  CLRPFM     FILE(MAOWRKPD)
                  CLRPFM     FILE(MAAWRKPD)
/*****************CLRPFM     FILE(MACARCPD)                 /*LN0381*/
                  CLRPFM     FILE(MAEXPTPD)                 /*LN0381*/
    /*                                                              */
    /* CLEAR TODAY'S REPORT PARAMETERS FILE                         */
    /*                                                              */
                  CLRPFM     FILE(FCPARDPD)
/*/COPY WNCPYSRC,FCC01001                                            */
    /*                                                              */
    /**SET*UP*PERIODIC*REQUESTS*TO*BE*RUN*TODAY                         LN1034*/
    /**IF**THIS*HAS*NOT*ALREADY*TAKEN*PLACE                             LN1034*/
    /*                                                              */
/**************** CALL       PGM(FC0010) PARM(&REPCON)                  LN1034*/
    /*                                                              */
    /**SET*DATA*AREA*REPSEQ*TO*NEXT*AVAILABLE*SEQUENCE*NUMBER           LN1034*/
    /**IF**THIS*HAS*NOT*ALREADY*TAKEN*PLACE***                          LN1034*/
    /*                                                              */
/**************** CHGVAR     VAR(&REPSEQ) VALUE(&REPCON)                LN1034*/
/**************** CHGDTAARA  DTAARA(REPSEQ) VALUE(&REPSEQ)              LN1034*/
/**/                                                                  /*E30569*/
/**    RESET THE VALUE IN DTAARA REPSEQ                                 E30569*/
                  CHGVAR     VAR(&REPSEQ) VALUE(&REPCON)              /*E30569*/
                  CHGDTAARA  DTAARA(REPSEQ) VALUE(&REPSEQ)            /*E30569*/
    /*                                                              */
    /* SET DATA AREA VALUE TO COPY COMPLETE                         */
    /*                                                              */
                  CHGVAR     VAR(&STATUS) VALUE(H)
                  CHGDTAARA  DTAARA(FCC01) VALUE(&STATUS)
             ENDDO
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       ABNOR
             ENDDO
             GOTO       CMDLBL(THEEND)
    /*                                                              */
 ABNOR:      SNDPGMMSG  MSG('R.C.F Input cycle initiation - +
                          Terminated Abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
 THEEND:     ENDPGM
