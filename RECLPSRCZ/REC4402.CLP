/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI branch monitor control')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4402 - CI Branch Monitor Control                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Note:   REC4402 must reside in the same library as REC4405. */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 25Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      164273             Date 29Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCI001             Date 10NOV98              */
/*                      139595             Date 22Jul98              */
/*                      124644             Date 21Oct97              */
/*                      118737             Date 21May97              */
/*                      117049             Date 21APR97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       CPK014 - Release 4 packaging:                               */
/*              - Ensure that the dtaq picks up the system ownership.*/
/*       164273 - Change 'Cashier 8' references to 'Cashier'         */
/*       CCI001 - Midas Cashier Enhancements - dtaq RECASH in XLIB   */
/*                not DILIB                                          */
/*       139595 - APYJOBDLBL no longer core and not required.        */
/*       124644 - Pass branch code as parameter instead of blanks    */
/*       118737 - Make Interface start-up crash-proof.               */
/*       117049 - Call to REC4411 using incorrect parameter list.    */
/*       CRT003 - Branch Automation Interface.                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BRCH &USID &UNID)
 
             DCL        VAR(&BRCH)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&USID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOBN)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)                                 /*CPK015*/
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)                                   /*CPK014*/
             DCL        VAR(&BMDTAARA)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTFDQ)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BRCA)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&BAII)   TYPE(*CHAR) LEN(264)
             DCL        VAR(&PROD)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQ)   TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&PRFX) VALUE(%SST(&UNID 1 2))
             CHGVAR     VAR(&BRCA) VALUE(%SST(&BRCH 1 3))
             CHGVAR     VAR(&XLIB) VALUE(&PRFX *CAT 'XLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *CAT 'DPLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&PRFX *CAT 'DPLIB')                           /*CPK015*/
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(QTEMP/LDA (1 3)) VALUE(&BRCA)
 
/**********  APYJOBDLBL JOBD(&XLIB/MIDASIC)                        */ /*139595*/
/**********  MONMSG     MSGID(CPF9999 CPF9898 CPF9810) EXEC(GOTO + */ /*139595*/
/**********               CMDLBL(ABNOR))                           */ /*139595*/
 
             RTVJOBA    NBR(&JOBN)
 
             CHGVAR     VAR(&BMDTAARA) VALUE('CASH_' *CAT &BRCA)
             CRTDTAARA  DTAARA(&DPLIB/&BMDTAARA) TYPE(*CHAR) LEN(1) +
                          VALUE(*) TEXT('CI Branch Monitor Data Area')
/************MONMSG*****MSGID(CPF1023) EXEC(GOTO CMDLBL(STARTED))     /*118737*/
             MONMSG     MSGID(CPF1023)                                /*118737*/
                                                                      /*118737*/
/* Attempt to allocate the data area. If it is already locked, then   /*118737*/
/* the branch monitor is already active.                              /*118737*/
                                                                      /*118737*/
             ALCOBJ     OBJ((&DPLIB/&BMDTAARA *DTAARA *EXCL)) +
                          WAIT(1)                                     /*118737*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(STARTED))     /*118737*/
                                                                      /*118737*/
 
             CHGVAR     VAR(&BTFDQ) VALUE('CASHTF_' *CAT &BRCA)
/*********** CRTDTAQ    DTAQ(&DPLIB/&BTFDQ) MAXLEN(29) +                      /*CCI001*/
/***********             TEXT('CI Branch Monitor Trickle Feed Data Queue')**/ /*CCI001*/
/************CRTDTAQ    DTAQ(&XLIB/&BTFDQ) MAXLEN(29) TEXT('CI +                          /*CPK015*/
/************             Branch Monitor Trickle Feed Data Queue')             /*CCI001*/ /*CPK015*/
             CRTDTAQ    DTAQ(&DTAQLIB/&BTFDQ) MAXLEN(29) TEXT('CI +
                          Branch Monitor Trickle Feed Data Queue')                        /*CPK015*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/* Correct the ownership of the dtaq */                                                   /*CPK014*/
/************RTVOBJD    OBJ(&XLIB) OBJTYPE(*LIB) OWNER(&OWNER)                 /*CPK014*/ /*CPK015*/
/************CHGOBJOWN  OBJ(XLIB/&BTFDQ) OBJTYPE(*DTAQ) +                              */ /*CPK015*/
/************             NEWOWN(&OWNER)                                       /*CPK014*/ /*CPK015*/
/************RTVOBJD    OBJ(&XLIB) OBJTYPE(*LIB) OWNER(&OWNER)                 /*CPK014*/ /*CPK015*/
/************CHGOBJOWN  OBJ(XLIB/&BTFDQ) OBJTYPE(*DTAQ) +                              */ /*CPK015*/
/************             NEWOWN(&OWNER)                                       /*CPK014*/ /*CPK015*/
             RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER)                         /*CPK015*/
             CHGOBJOWN  OBJ(&DTAQLIB/&BTFDQ) OBJTYPE(*DTAQ) +
                          NEWOWN(&OWNER)                                                  /*CPK015*/
 
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
/***********   CALL       PGM(REC4411) PARM('REC4402' &JOBN '0000' +
/***********              'USR0052' '   ' ' ' ' ')                    /*117049*/
/***********   CALL       PGM(REC4411) PARM('REC4402' &JOBN '0000' +
/***********              '   ' 'USR0052' ' ')             /*117049*/ /*124644*/
               CALL       PGM(REC4411) PARM('REC4402' &JOBN '0000' +
                          &BRCA 'USR0052' ' ')                        /*124644*/
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&PROD) VALUE(%SST(&BAII 15 10))
 
/**********  IF         COND((&RTCD *EQ '       ') *AND +
/**********               (&PROD *EQ 'CASHIER 8 ')) THEN(DO) */       /*164273*/
             IF         COND((&RTCD *EQ '       ') *AND +
                          (&PROD *EQ 'CASHIER   ')) THEN(DO)          /*164273*/
               CHGVAR   VAR(&JOBQ) VALUE(%SST(&BAII 58 10))
 
               ADDICFDEVE FILE(RE4402CM) PGMDEV(CIPGMD) +
                            RMTLOCNAME(*REQUESTER) CMNTYPE(*APPC)
               MONMSG     MSGID(CPF7365)
 
               TFRJOB     JOBQ(&XLIB/&JOBQ) RTGDTA('BRANCH MONITOR')
 
               GOTO     CMDLBL(END)
             ENDDO
 
 STARTED:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Branch Monitor Is Already  +
                          Running') TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Branch Monitor Program REC4402 Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF2469) EXEC(DO)
                        SNDPGMMSG MSG('CI Branch Program REC4402 +
                          Ended Abnormally') TOMSGQ(QSYSOPR)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 ENDPGM:     ENDPGM
