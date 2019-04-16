/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Delete SPLF from  output queues')            */
/*OVR  : OVRDBF FILE(TMPSPLF) TOFILE(FCTMPPD)                       :*/
/*OVR  : CRTPF QTEMP/OUTQF RCDLEN(133)                              :*/
/*********************************************************************/
/*                                                                   */
/*  Midas - Microfiche/Optical Disk Archiving Module             */
/*                                                                   */
/*  MAC0608  - Delete SPLF from Output Queues                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD039095           Date 16Apr19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      244680             Date 12Jan07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      089639  *CREATE    Date 11Jul95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  MD039095 - Correct the position of fields 'Page' and include the */
/*             year in the condition for dates.                      */
/*  MD046248 - Finastra Rebranding                                   */
/*  244680 - Correct the position of all the affected fields due to  */
/*           OS Version V5R1.                                        */
/*         - Correct variable setting to properly remove old spool   */
/*           files. Apply 216913.                                    */
/*  089636 - Delete individual spool entry rather than clear the     */
/*           whole output queue.  Deletion will be based on date     */
/*           and time MAC0607 is run.                                */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*********************************************************************/
             PGM        PARM(&EAAOTQ &SDATE &STIME)

             DCL        VAR(&EAAOTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
/**********  DCL        VAR(&SDATF) TYPE(*CHAR) LEN(4)                                  /*MD039095*/
             DCL        VAR(&SDATF) TYPE(*CHAR) LEN(6)                                  /*MD039095*/
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPFNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPUSR) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&SPSNO) TYPE(*DEC)  LEN(3 0)                                /*MD039095*/
             DCL        VAR(&SPSNO) TYPE(*DEC)  LEN(5 0)                                /*MD039095*/
             DCL        VAR(&SPJNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPJNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SPDAY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SPMTH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SPHR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SPMIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SPSEC) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&SPDAT) TYPE(*CHAR) LEN(4)                                  /*MD039095*/
             DCL        VAR(&SPDAT) TYPE(*CHAR) LEN(6)                                  /*MD039095*/
             DCL        VAR(&SPAGE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SPTIM) TYPE(*CHAR) LEN(6)
/**********  DCL        VAR(&SPDTM) TYPE(*CHAR) LEN(10)                                 /*MD039095*/
/**********  DCL        VAR(&SDTTM) TYPE(*CHAR) LEN(10)                                 /*MD039095*/
             DCL        VAR(&SPDTM) TYPE(*CHAR) LEN(12)                                 /*MD039095*/
             DCL        VAR(&SDTTM) TYPE(*CHAR) LEN(12)                                 /*MD039095*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&SPYEA) TYPE(*CHAR) LEN(2)                                  /*MD039095*/
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)                                 /*MD039095*/
             DCL        VAR(&FROMFMT) TYPE(*CHAR) LEN(4)                                /*MD039095*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCLF       FILE(QTEMP/OUTQF)

             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))

             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                                    /*MD039095*/
/** Retrieve the system date format */                                                  /*MD039095*/
/**/                                                                                    /*MD039095*/
             RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)                                 /*MD039095*/
/**/
/**   CONVERT SDATE TO SDATF FOR COMPARISON                                **/
/**/
/**********  CHGVAR     VAR(&SDATF) VALUE(%SST(&SDATE 3 2) *TCAT +  */                  /*MD039095*/
/**********              %SST(&SDATE 1 2))                          */                  /*MD039095*/
/**/                                                                                    /*MD039095*/
/* Handle each type of date format provided by IBM */                                   /*MD039095*/
/* Convert to 'YMD' for program purposes           */                                   /*MD039095*/
/**/                                                                                    /*MD039095*/
                                                                                        /*MD039095*/
             IF         COND((&DATFMT *EQ 'DMY') *OR (&DATFMT *EQ +
                          'MDY') *OR (&DATFMT *EQ 'JUL')) THEN(DO)                      /*MD039095*/
                         CHGVAR     VAR(&FROMFMT) VALUE('*' *CAT &DATFMT)               /*MD039095*/
                         CVTDAT   DATE(&SDATE) TOVAR(&SDATF) +
                          FROMFMT(&FROMFMT) TOFMT(*YMD) TOSEP(*NONE)                    /*MD039095*/
             ENDDO                                                                      /*MD039095*/
             ELSE       CMD(DO)                                                         /*MD039095*/
                        CHGVAR     VAR(&SDATF) VALUE(&SDATE)                            /*MD039095*/
             ENDDO                                                                      /*MD039095*/


/**/
/*  SECURE TEMPORARY PHYSICAL FILE FOR SPOOL FILE ENTRIES           */
             DLTF       FILE(QTEMP/OUTQF)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/OUTQF) RCDLEN(133)
             MONMSG     MSGID(CPF0000)
/**/
/**   CONVERT SPOOL OUTPUT QUEUE TO DATABASE FILE                          **/
/**/
             WRKOUTQ    OUTQ(*LIBL/&EAAOTQ) OUTPUT(*PRINT)
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(QTEMP/OUTQF) +
                          SPLNBR(*LAST)
             DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)
/**/
/*  SCAN LIST OF SPOOLED FILES UNTIL HEADINGS FOUND                 */
READ1:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&SFILE) VALUE(%SST(&OUTQF 2 10))
             IF         COND(&SFILE *NE 'File') THEN(GOTO +
                          CMDLBL(READ1))
/**/
/*  READ ATTRIBUTES OF SPOOLED FILE ENTRIES                        */
READ2:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&SFILE) VALUE(%SST(&OUTQF 2 10))
/**********  CHGVAR     VAR(&SPAGE) VALUE(%SST(&OUTQF 119 4))                           /*MD039095*/
             CHGVAR     VAR(&SPAGE) VALUE(%SST(&OUTQF 122 4))                           /*MD039095*/
/**/
/*  IF NO DATA OR NEXT PAGE, SKIP AND LOOK FOR NEXT HEADING        */
             IF         COND((&SFILE *EQ '          ') *OR (&SFILE +
                          *EQ '        * ') *OR (&SPAGE *EQ +
                          'Page')) THEN(GOTO CMDLBL(READ1))
/**/
/*  PLACE ATTRIBUTE VALUES INTO WORK FIELDS                        */
             CHGVAR     VAR(&SPFNM) VALUE(%SST(&OUTQF 2 10))
             CHGVAR     VAR(&SPUSR) VALUE(%SST(&OUTQF 13 10))
/**********  CHGVAR     VAR(&SPSNO) VALUE(%SST(&OUTQF 74 3)) */                           /*244680*/
             CHGVAR     VAR(&SPSNO) VALUE(%SST(&OUTQF 74 5))                              /*244680*/
/**/
/*  IF DATA IS NON-READABLE, ASSUME END OF FILE                    */
             MONMSG     MSGID(CPG0818 CPF0818) EXEC(GOTO +
                          CMDLBL(END))
/**********  CHGVAR     VAR(&SPJNM) VALUE(%SST(&OUTQF 82 10)) */                          /*244680*/
             CHGVAR     VAR(&SPJNM) VALUE(%SST(&OUTQF 84 10))                             /*244680*/
/**********  CHGVAR     VAR(&SPJNO) VALUE(%SST(&OUTQF 93 6)) */                           /*244680*/
             CHGVAR     VAR(&SPJNO) VALUE(%SST(&OUTQF 95 6))                              /*244680*/
/**********  CHGVAR     VAR(&SPDAY) VALUE(%SST(&OUTQF 100 2)) */                          /*244680*/
             CHGVAR     VAR(&SPDAY) VALUE(%SST(&OUTQF 102 2))                             /*244680*/
/**********  CHGVAR     VAR(&SPMTH) VALUE(%SST(&OUTQF 103 2)) */                          /*244680*/
             CHGVAR     VAR(&SPMTH) VALUE(%SST(&OUTQF 105 2))                             /*244680*/
/**********  CHGVAR     VAR(&SPHR) VALUE(%SST(&OUTQF 109 2))  */                          /*244680*/
             CHGVAR     VAR(&SPHR) VALUE(%SST(&OUTQF 111 2))                              /*244680*/
/**********  CHGVAR     VAR(&SPMIN) VALUE(%SST(&OUTQF 112 2)) */                          /*244680*/
             CHGVAR     VAR(&SPMIN) VALUE(%SST(&OUTQF 114 2))                             /*244680*/
/**********  CHGVAR     VAR(&SPSEC) VALUE(%SST(&OUTQF 115 2)) */                          /*244680*/
             CHGVAR     VAR(&SPSEC) VALUE(%SST(&OUTQF 117 2))                             /*244680*/
             CHGVAR     VAR(&SPYEA) VALUE(%SST(&OUTQF 108 2))                           /*MD039095*/
/**********  CHGVAR     VAR(&SPDAT) VALUE(&SPMTH *TCAT &SPDAY)                          /*MD039095*/
             CHGVAR     VAR(&SPDAT) VALUE(&SPDAY *TCAT &SPMTH *TCAT &SPYEA)             /*MD039095*/
                                                                                        /*MD039095*/
             IF         COND((&DATFMT *EQ 'DMY') *OR (&DATFMT *EQ +
                          'MDY') *OR (&DATFMT *EQ 'JUL')) THEN(DO)                      /*MD039095*/
                         CVTDAT   DATE(&SPDAT) TOVAR(&SPDAT) +
                          FROMFMT(&FROMFMT) TOFMT(*YMD) TOSEP(*NONE)                    /*MD039095*/
             ENDDO                                                                      /*MD039095*/
                                                                                        /*MD039095*/
             CHGVAR     VAR(&SPTIM) VALUE(&SPHR *TCAT &SPMIN *TCAT &SPSEC)
/**/
/**   CHECK IF SPOOL FILE ENTRY CAN BE DELETED                               **/
/**/
             CHGVAR     VAR(&SPDTM) VALUE(&SPDAT *TCAT &SPTIM)
             CHGVAR     VAR(&SDTTM) VALUE(&SDATF *TCAT &STIME)
             IF         COND(&SPDTM *LT &SDTTM) THEN(DO)
             DLTSPLF    FILE(&SPFNM) JOB(&SPJNO/&SPUSR/&SPJNM) +
                          SPLNBR(&SPSNO)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DSPLERR))
             ENDDO
/**/
/*  READ NEXT SPOOLED FILE RECORD                                  */
             GOTO       CMDLBL(READ2)
/**/
/*  ERROR ON DELETING THE PHYSICAL FILE OR COPY OF SPOOL TO PHYSICAL */
/*  FILE.                                                           */
DSPLERR:     CHGVAR     VAR(&MSG) VALUE('Error occured on' *BCAT  +
                          &EAAOTQ *BCAT 'while deleting spool file' +
                          *BCAT &SPFNM *BCAT '.')
             SNDMSG     MSG(&MSG) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(READ2)
/**/
END:    ENDPGM
