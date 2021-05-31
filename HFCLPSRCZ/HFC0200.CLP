/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF extract journal entries in COB')             */
/*********************************************************************/
/*                                                                   */
/*  Midas - History and Audit Facility Module                        */
/*                                                                   */
/*  HFC0200  - EXTRACT JOURNAL ENTRIES IN COB                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. 253037             Date 01Jun20              */
/*       Prev Amend No. 249112             Date 01Jun20              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      107487             Date 28Feb97              */
/*                      112986             DATE 13FEB97              */
/*                      099185             DATE 10JUL96              */
/*                      093194             DATE 24APR96              */
/*                      092896             DATE 24APR96              */
/*                      091505             DATE 19OCT95              */
/*                      084645             DATE 19OCT95              */
/*                      088064             DATE 16JUN95              */
/*                      069864             DATE 12MAY94              */
/*                      049980             DATE 01FEB93              */
/*                      048613             DATE 16DEC92              */
/*                      S01379             DATE 15SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       253037 - Suppress generation of program dump when NDSUJR    */
/*                record is not found in SCJSEQPD.                   */
/*       249112 - SFDC 00192180. Apply fix SC#240261 / SFDC 00126651 */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*      107487  - XX is secured using AUTL so all user's will        */
/*                already have access. This oobject is created with  */
/*                *LIBCRTAUT from the xxHFLIB so the operator running*/
/*                the COB should not need to be able to GRT *PUBLIC  */
/*                *ALL.                                              */
/*      112986  - Do not display journal entries if no files are     */
/*                being monitored (i.e No rcd on HFFILEPD).          */
/*      099185  - HAF uses date format DDMMYY, so change job to use  */
/*                date format *DMY.                                  */
/*              - If HAF extract file XX contains entries for 2 days,*/
/*                extracted data is not in chronological order. Fix  */
/*                is to change format of OPNQRYF to be keyed on field*/
/*                YYMMDD, which means that file is in correct date   */
/*                order.  New file definition HFJRNXXPD added to     */
/*                xxDPLIB for this fix.                              */
/*       093194 - COMPLETION OF 091505 - IF FILE CANNOT BE ALLOCATED */
/*       092896 - WRONG RECORDS DROPPED BY HF0200 IN CASE OF RESTART */
/*                DUE TO RESEQUENCE BY OPNQRYF (IDENTICAL RECORDS    */
/*                ARE GROUPED - HF0200 PRESUMES UP AFTER UB)         */
/*       091505 - ADD LOOP TO RETRY WHEN MEMBER CANNOT BE ALLOCATED  */
/*       084645 - ADJUST LENGHT (SPACE DISK)                         */
/*       088064 - Adjust processing knowing that limit of files for  */
/*                command DSPJRN is 50 and then sort XX for later use*/
/*              - BLI. Add MONSMG CPF0006                            */
/*       069864 - Monitor for non-existance of the XX file during    */
/*                SCBEGIN.                                           */
/*       049980 - Access AOHAFDR0 to determine the value of field    */
/*                ETSAVE (Save HAF data to media.)                   */
/*       048613 - Program failed when there were no journal entries; */
/*                MONMSG applied.                                    */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&X) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&CURREC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&HFREC) TYPE(*DEC) LEN(10 0) VALUE(0)     /*088064*/
             DCL        VAR(&HFCPT) TYPE(*DEC) LEN(2 0) VALUE(0)      /*088064*/
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)  +
                           VALUE('*DBERR ')                           /*049980*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)  +
                           VALUE('*FIRST ')                           /*049980*/
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)                 /*049980*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*049980*/
             DCL        VAR(&LGTH) TYPE(*CHAR) LEN(4)                 /*088064*/
             DCL        VAR(&NBRRCD) TYPE(*DEC) LEN(10 0)             /*112986*/
             DCL        VAR(&STRRCV) TYPE(*CHAR) LEN(10)                                  /*CSC020*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                 /*CSC020*/
             DCL        VAR(&STRSEQA) TYPE(*CHAR) LEN(10)                                 /*CSC020*/
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(50)                                     /*249112*/
             DCL        VAR(&YRL) TYPE(*CHAR) LEN(5)                                      /*249112*/
             DCL        VAR(&RCOD) TYPE(*CHAR) LEN(1)                                     /*249112*/
 
             DCLF       FILE(HFFILEPD)
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
                                                                     /*099185*/
/* Change Date Format to be DDMMYY, which is the format used by HAF.  *099185*/
             CHGJOB     DATFMT(*DMY)                                 /*099185*/
/**/                                                                  /*088064*/
/* RETRIEVE MAX LENGTH FOR DSPJRN */                                  /*088064*/
/**/                                                                  /*088064*/
             CALL       PGM(HF0201) PARM(&LGTH)                       /*088064*/
             DLTUSRSPC  USRSPC(QTEMP/RCDSPC)                          /*088064*/
             MONMSG     MSGID(CPF0000)                                /*088064*/
 
/* */                                                                 /*049980*/
/* Get ICD information on 'Save HAF data to media' */                 /*049980*/
/* */                                                                 /*049980*/
             CALL       AOHAFDR0 PARM(&RTCD &OPTN &DSFDY)             /*049980*/
             CHGVAR     VAR(&SAVE) VALUE(%SST(&DSFDY 20 1))           /*049980*/
                                                                      /*049980*/
/*                                                                                          CSC020*/
/*  Determine journal sequence number of next day set up.                                   CSC020*/
/*  (Equivalent to beginning of ICRCV001 in previous releases)                              CSC020*/
/*                                                                                          CSC020*/
/*           SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ) */            /*CSC020 253037*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ) +
                          PGM(HFC0200)                                                    /*253037*/
/*                                                                                          CSC020*/
/*  If no value returned, then set sequence to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRSEQ *EQ 0) THEN(DO)                                      /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNSEQNBR(&STRSEQ)                                              /*CSC020*/
             ENDDO                                                                        /*CSC020*/
             CHGVAR     VAR(&STRSEQA) VALUE(&STRSEQ)                                      /*CSC020*/
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
/* */                                                                 /*049980*/
/* If the HAF save option is not active then clear down PF/XX */      /*049980*/
/* */                                                                 /*049980*/
/************IF         COND(&SAVE *NE 'Y') THEN(CLRPFM + *********** /*069864*/
/*************************FILE(&HFLIB/XX))**************** /*049980*/ /*069864*/
             IF         COND(&SAVE *NE 'Y') THEN(DO)
             CLRPFM FILE(&HFLIB/XX)                                   /*069864*/
             MONMSG     MSGID(CPF3142)                                /*069864*/
             ENDDO                                                    /*069864*/
                                                                      /*049980*/
/* */
/* Set up the DSPJRN variable */
/* */
/**/                                                                  /*088064*/
/* Get the description of the file HFFILEPD */                        /*088064*/
/**/                                                                  /*088064*/
             RTVMBRD    FILE(HFFILEPD) NBRCURRCD(&HFREC)              /*088064*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&HFREC) +
                          VALUE(0))                                   /*088064*/
/**/                                                                  /*088064*/
/* Get the description of the work file XX */                         /*088064*/
/**/                                                                  /*088064*/
             RTVMBRD    FILE(&HFLIB/XX) NBRCURRCD(&CURREC)            /*088064*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&CURREC) +
                          VALUE(0))                                   /*088064*/
REDSP:                                                                /*088064*/
/************CHGVAR*****VAR(&X)*VALUE('DSPJRN RCVRNG(ICRCV001*+*****************************CSC020*/
/**************************CURRENT)*JRN(ICJRN)*FILE(')**************************************CSC020*/
             CHGVAR     VAR(&X) VALUE('DSPJRN RCVRNG(*CURCHAIN+
                          )         JRN(ICJRN) FILE(')                                    /*CSC020*/
 
 
/* */
/* Create dataraea JRNMOD in QTEMP and initialise it */
/* */
             DLTDTAARA  DTAARA(QTEMP/JRNMOD)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/JRNMOD) TYPE(*CHAR) LEN(6) +
                          VALUE('EODAUD') TEXT('mode of run')
 
/* */
/* If HFFILEPD is empty then do no further processing */              /*112986*/
/* */
             RTVMBRD    FILE(HFFILEPD) NBRCURRCD(&NBRRCD)             /*112986*/
             IF         COND(&NBRRCD *EQ 0) THEN(GOTO CMDLBL(END))    /*112986*/
 
/* */
/* Read all records from HFFILEPD */
/* */
 RETRY:      RCVF
/* */
/* EOF. Goto main processing section */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(MAIN))
 
/* */
/* If the file is not enabled then read the next record */
/* */
             IF         COND(&ENAB *NE 'E') +
                          THEN(GOTO CMDLBL(RETRY))
 
/* */
/* Add this file name onto the end of the DSPJRN variable */
/* */
             CHGVAR     VAR(&X) VALUE(&X *BCAT '(*LIBL/' *TCAT +
                          &FFORM *TCAT ' *ALL)')
/**/                                                                  /*088064*/
/* Check number of files to display-Limit of 50 files */              /*088064*/
/**/                                                                  /*088064*/
             CHGVAR     VAR(&HFCPT) VALUE(&HFCPT + 1)                 /*088064*/
             IF         COND(&HFCPT *GE 50) THEN(DO)                  /*088064*/
             GOTO       CMDLBL(MAIN)                                  /*088064*/
             ENDDO                                                    /*088064*/
/**/                                                                  /*088064*/
 
/* */
/* Next record */
/* */
             GOTO       CMDLBL(RETRY)
 
/* */
/* Main processing section */
/* Complete the DSPJRN variable */
/* */
/* BEGIN 084645 */
/*MAIN:*******CHGVAR     VAR(&X) VALUE(&X *BCAT ') JRNCDE(R)' *BCAT +     */
/*************            'ENTDTALEN(9874) OUTPUT(*OUTFILE)' *BCAT +      */
/*************            'OUTFILE(' *TCAT &HFLIB *TCAT '/XX) +           */
/*************            OUTMBR(*FIRST *ADD)')                           */
/*MAIN:******CHGVAR     VAR(&X) VALUE(&X *BCAT ') JRNCDE(R)' *BCAT +
                          'ENTDTALEN(' *TCAT &LGTH *TCAT ') +
                          OUTPUT(*OUTFILE)' *BCAT 'OUTFILE(' *TCAT +
                          &HFLIB *TCAT '/XX) OUTMBR(*FIRST *ADD)')**************************CSC020*/
 MAIN:       CHGVAR     VAR(&X) VALUE(&X *BCAT ') JRNCDE(R)' *BCAT +
                          'ENTDTALEN(' *TCAT &LGTH *TCAT ') +
                          OUTPUT(*OUTFILE)' *BCAT 'OUTFILE(' *TCAT +
                          &HFLIB *TCAT '/XX) OUTMBR(*FIRST *ADD) +
                          FROMENT(' *TCAT &STRSEQA *TCAT ')')                             /*CSC020*/
/* END   084645 */
 
/* */
/* Get the description of the work file XX */
/* */
/*********** RTVMBRD    FILE(&HFLIB/XX) NBRCURRCD(&CURREC)            /*088064*/
/*********** MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&CURREC) +     /*088064*/
/***********              VALUE(0))                                   /*088064*/
 
/** Check if file XX is journalled, then ENDJRNPF */                                      /*249112*/
             CALL       PGM(HFC0110) PARM('XX' &TXT &YRL &RCOD)                           /*249112*/
             IF         COND(&RCOD *NE 'R') THEN(DO)                                      /*249112*/
                ENDJRNPF   FILE(&HFLIB/XX)                                                /*249112*/
                MONMSG     MSGID(CPF9812)                                                 /*251296*/
             ENDDO                                                                        /*249112*/
/* */
/* Check that the work file XX exists. If not create it. */
/* Ensuring that there is no data in the file */
/* */
             CHKOBJ     OBJ(&HFLIB/XX) OBJTYPE(*FILE) AUT(*NONE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
/* BEGIN 084645 */
/**************DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 ICRCV001) +          */
/**************             NBRENT(1) JRNCDE(R) PGM(DUMMYPROG) +          */
/**************             ENTDTALEN(9874) OUTPUT(*OUTFILE) +            */
/**************             OUTFILE(&HFLIB/XX) OUTMBR(*FIRST *REPLACE)    */
/************DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 ICRCV001) +
                          NBRENT(1) JRNCDE(R) PGM(DUMMYPROG) +
                          OUTPUT(*OUTFILE) OUTFILE(&HFLIB/XX) +
                          OUTMBR(*FIRST *REPLACE) ENTDTALEN(&LGTH)**************************CSC020*/
             DSPJRN     JRN(ICJRN) RCVRNG(*CURCHAIN) +
                          FROMENT(&STRSEQ) NBRENT(1) JRNCDE((R)) +
                          PGM(DUMMYPROG) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/XX) OUTMBR(*FIRST +
                          *REPLACE) ENTDTALEN(&LGTH)                                      /*CSC020*/
/* END   084645 */
               MONMSG     MSGID(CPF7062)
               CLRPFM     FILE(&HFLIB/XX)
               MONMSG     MSGID(CPF0000)
             CHGPF      FILE(&HFLIB/XX) MAXMBRS(*NOMAX) SIZE(*NOMAX)
             ENDDO
 
/* */
/* Call QCMDEXC to execute the DSPJRN variable stored in &X */
/* */
RETRY2:                                                      /*091505*/
             CALL       PGM(QCMDEXC) PARM(&X 5000)
             MONMSG     MSGID(CPF7062)                                /*048613*/
                                                             /*091505*/
/**********  MONMSG     MSGID(CPF7007) EXEC(DO)  ******* 091505093194*/
             MONMSG     MSGID(CPF7007 CPF9803) EXEC(DO)      /*093194*/
             DLYJOB     DLY(60)                              /*091505*/
             GOTO       RETRY2                               /*091505*/
             ENDDO                                           /*091505*/
 
/* */
/* If command fails then do a generic DSPJRN to file XX */
/* */
             MONMSG     MSGID(CPF7060 CPF7006) EXEC(DO)
/* BEGIN 084645 */
/**************DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 *CURRENT) +          */
/**************             JRNCDE(R) ENTDTALEN(9874) +                   */
/**************             OUTPUT(*OUTFILE) OUTFILE(&HFLIB/XX) +         */
/**************             OUTMBR(*FIRST *ADD)                           */
/************DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 *CURRENT) +
                          JRNCDE(R) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/XX) OUTMBR(*FIRST *ADD) +
                          ENTDTALEN(&LGTH)**************************************************CSC020*/
             DSPJRN     JRN(ICJRN) RCVRNG(&STRRCV *CURRENT) +
                          JRNCDE((R)) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/XX) OUTMBR(*FIRST *ADD) +
                          ENTDTALEN(&LGTH)                                                /*CSC020*/
/* END   084645 */
               MONMSG     MSGID(CPF7062)
             ENDDO
/**/                                                                  /*088064*/
/* Check number of files to display-Limit of 50 files */              /*088064*/
/**/                                                                  /*088064*/
             IF         COND(&HFCPT *GE 50) THEN(DO)                  /*088064*/
             CHGVAR     VAR(&HFCPT) VALUE(0)                          /*088064*/
             CHGVAR     VAR(&X) VALUE(' ')                            /*088064*/
             GOTO       CMDLBL(REDSP)                                 /*088064*/
             ENDDO                                                    /*088064*/
             ELSE       CMD(DO)                                       /*088064*/
             IF         COND(&HFREC *GT 50) THEN(DO)                  /*088064*/
/************OVRDBF     FILE(XX) TOFILE(&HFLIB/XX) SHARE(*YES) 088064   099185*/
/*  Eliminate duplicate records (important in case of restart)   */   /*092896*/
/************OPNQRYF    FILE((&HFLIB/XX)) KEYFLD((JODATE *ASCEND) +
                          (JOTIME *ASCEND) (JOSEQN *ASCEND))    ***** /*092896*/
/************OPNQRYF    FILE((&HFLIB/XX)) KEYFLD((JODATE *ASCEND) +*/ /*099185*/
/************             (JOTIME *ASCEND) (JOSEQN *ASCEND)) +     */ /*099185*/
/************             UNIQUEKEY(*ALL)                       *092896 099185*/
             OVRDBF     FILE(HFJRNXXPD) TOFILE(&HFLIB/XX) +
                        SHARE(*YES)                                   /*099185*/
             OPNQRYF    FILE((&HFLIB/XX *FIRST)) FORMAT(HFJRNXXPD) +
                          KEYFLD((YYMMDD *ASCEND) (JOTIME *ASCEND) +
                          (JOSEQN *ASCEND)) UNIQUEKEY(*ALL) +
                          MAPFLD((YYMMDD '%SST(JODATE 5 2) *cat +
                          %SST(JODATE 3 2) *cat %SST(JODATE 1 2)' +
                          *CHAR 6))                                   /*099185*/
             CPYFRMQRYF FROMOPNID(XX) TOFILE(&HFLIB/XX2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*088064*/
             CLOF       OPNID(XX)                                     /*088064*/
/************DLTOVR     FILE(XX)                             *088064* /*099185*/
             DLTOVR     FILE(HFJRNXXPD)                               /*099185*/
             CPYF       FROMFILE(&HFLIB/XX2) TOFILE(&HFLIB/XX) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*099185*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&HFLIB/XX))                            /*099185*/
/*************************MBROPT(*REPLACE) CRTFILE(*YES)   *088064*   /*099185*/
             DLTF       FILE(&HFLIB/XX2)                              /*088064*/
             ENDDO                                                    /*088064*/
             ENDDO                                                    /*088064*/
 
/* */
/* Delete entries that are superfluous */
/* */
             OVRDBF     FILE(JOURNAL) TOFILE(&HFLIB/XX)
             CALL       PGM(HF0200)
/**********  RGZPFM     FILE(&HFLIB/XX)                                                   /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                /*048613*/          /*228542*/
             CALL       PGM(SCC000060) PARM('XX' '*FIRST')                                /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
/* */
/* Call HF0230 to remove duplicate entries */
/* */
             CHGPF      FILE(HFDUPEPD) SIZE(*NOMAX)
             CLRPFM     FILE(HFDUPEPD)
             CHGJOB     SWS(0XXXXXXX)
 
             IF         COND(&CURREC *NE 0) THEN(DO)
             CALL       PGM(HF0230)
/**********  RGZPFM     FILE(&HFLIB/XX)                                                   /*228542*/
             CALL       PGM(SCC000060) PARM('XX' '*FIRST')                                /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
             ENDDO
 
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DAT)
             CHGDTAARA  DTAARA(HFSAVE (1 6)) VALUE(&DAT)
 
/* */
/* Copy the entries from the extract file XX into the database files */
/* */
             CALL       PGM(HFC0220)
 
/* */
/*If duplicate entries or old entries added */
/* Reorganise all items */
/* */
             IF         COND(%SWITCH(1XXXXXXX) *OR &CURREC *NE 0) +
                          THEN(DO)
             CALL       PGM(HFC0230)
             CHGJOB     SWS(0XXXXXXX)
             ENDDO
 
/* */
/* Print audit report   */
/* */
             CALL       PGM(HFC0240)
 
/* */
/* Delete entries beyond retention period  */
/* */
             CALL       PGM(HFC0210)
 
/* */
/* Allow other users to access the XX file */
/* */
/************GRTOBJAUT  OBJ(&HFLIB/XX) OBJTYPE(*FILE) USER(*PUBLIC) + /*107487*/
/************             AUT(*ALL)                                   /*107487*/
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0200 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CALL       PGM(AOHAFDR0) PARM(&RTCD '*FREE' &DSFDY)      /*049980*/
 
             ENDPGM
