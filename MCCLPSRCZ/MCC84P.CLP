/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Management Account Balance Prompt')          */
/********************************************************************/
/*                                                                  */
/*       Midas     Management Accounts Module                   */
/*                                                                  */
/*       MCC84P - Management Account Balance Prompt 2               */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. AR1051497          Date 11Feb13             */
/*       Prev Amend No. 201060             Date 18Dec01             */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01416             Date 17May93              */
/*                      XXXXXX             DATE XXXXXXX             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       AR1051497 - Problems with selection criteria screen        */
/*                (Child 1051500)                                   */
/*       201060 - CPF0817 received by MCC84. Applied fix 142748.    */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*       S01416 - Account Balances Report                           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSLV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RETC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ANAL) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PERSET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPDN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&IN66) TYPE(*LGL) LEN(1)
/*/COPY WNCPYSRC,MCC84P001                                           */
/**/
             DCLF       FILE(MCC84DF)
/**/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)
             RTVJOBA    JOB(&SWSID) USER(&SUSER)
/*/COPY WNCPYSRC,MCC84P002                                           */
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&RSNO) VALUE(%SST(&RPARM 2 1))
             CHGVAR     VAR(&RSLV) VALUE(%SST(&RPARM 3 1))
             CHGVAR     VAR(&RPCD) VALUE(%SST(&RPARM 4 1))
             CHGVAR     VAR(&GRPCD) VALUE(%SST(&RPARM 5 2))
             CHGVAR     VAR(&SRPDN) VALUE(%SST(&RPARM 7 4))
             CHGVAR     VAR(&TERM1) VALUE(%SST(&RPARM 11 1))
             CHGVAR     VAR(&TERM2) VALUE(%SST(&RPARM 12 1))
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 13 1))
             CHGVAR     VAR(&ANAL) VALUE(%SST(&RPARM 14 9))
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&RSLV) VALUE('9')
             CHGVAR     VAR(&RPCD) VALUE('Y')
             CHGVAR     VAR(&TERM1) VALUE('P')
             CHGVAR     VAR(&TERM2) VALUE('Y')
             ENDDO
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN03) +
                          VALUE('1'))
/**/
ERRMC:
             SNDRCVF    RCDFMT(MCC84MC)
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN14) VALUE('0')
             CHGVAR     VAR(&IN17) VALUE('0')
             CHGVAR     VAR(&IN18) VALUE('0')
             CHGVAR     VAR(&IN19) VALUE('0')
             CHGVAR     VAR(&IN20) VALUE('0')
             CHGVAR     VAR(&IN21) VALUE('0')
             CHGVAR     VAR(&IN66) VALUE('0')
/* IF F3, RETURN TO RCF WITH ACTION CODE = END  */
             IF         COND(&IN01 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('E')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/* IF F12, RETURN TO RCF WITH ACTION CODE = FIRST SCREEN */
             IF         COND(&IN02 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('F')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/* IF F10, RETURN TO RCF WITH ACTION CODE = DELETE */
             IF         COND(*IN04 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('D')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/* CONTROL GROUP MUST BE ON FILE */
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &GRPCD +
                          &DSFDY)
             IF         COND(&RTCD *NE '       ') THEN(DO)
             CHGVAR     VAR(&IN17) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('Control Group does not +
                          exist on file')
             GOTO       CMDLBL(ERRMC)
             ENDDO
             CHGVAR VAR(&PERSET) VALUE(%SST(&DSFDY 33 1))
/* RELATIVE PERIOD MUST BE BLANK IF CONTROL GROUP IS BLANK         */
             IF         COND(&SRPDN *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN18) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('Relative Period must be +
                        entered')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/* RELATIVE PERIOD MUST EXIST FOR CONTROL GROUP SELECTED OR BE '0' */
             CHGVAR     VAR(&RPDN) VALUE(&SRPDN)
/* RELATIVE PERIOD NUMBER MUST BE IN THE RANGE -999 TO 999                AR1051497*/
             MONMSG     MSGID(CPF0817) EXEC(DO)                        /* AR1051497*/
             CHGVAR     VAR(&IN18) VALUE('1')                          /* AR1051497*/
             CHGVAR     VAR(&MSG2) VALUE('Relative Period must be +
                        in the range -999 to 999')                     /* AR1051497*/
             GOTO       CMDLBL(ERRMC)                                  /* AR1051497*/
             ENDDO                                                     /* AR1051497*/
                                                                       /* AR1051497*/
             MONMSG     MSGID(CPF0818) EXEC(DO)
             CHGVAR     VAR(&IN66) VALUE('1')
             GOTO       CMDLBL(SKIP)
             ENDDO
             MONMSG     MSGID(CPF0817) EXEC(DO)                       /*201060*/
             CHGVAR     VAR(&IN18) VALUE('1')                         /*201060*/
             CHGVAR     VAR(&MSG2) VALUE('Relative Period must be in -
                        the range -999 to 999')                       /*201060*/
             GOTO       CMDLBL(ERRMC)                                 /*201060*/
             ENDDO                                                    /*201060*/
             IF         COND(&SRPDN *NE '   ') THEN(DO)
             CHGVAR     VAR(&SRPDN) VALUE(&RPDN)
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)
/******      IF         COND(&RTCD *NE '       ') THEN(DO)                 *****/      /*AR1051497*/
             IF         COND((&RTCD *NE '       ') *AND (&RTCD *NE 'TERM1  ') +
                        *AND (&RTCD *NE 'TERM2  ')) THEN(DO)                           /*AR1051497*/
             CHGVAR     VAR(&IN18) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('Relative Period does not +
                          exist for this Control Group')
             GOTO       CMDLBL(ERRMC)
             ENDDO
             ENDDO
SKIP:
             IF         COND((&GRPCD *NE '   ') *AND (&IN66 *EQ +
                          '1')) THEN(DO)
             CHGVAR     VAR(&IN18) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('Relative Period must be +
                          a numeric value')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/* CCY FIELD ENTRY MANDATORY */
             IF         COND(&CCY *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Blank not a valid entry')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/*/COPY WNCPYSRC,MCC84P003                                           */
/* CCY MUST BE ONE OF 'A', 'B', 'H' OR 'L' */
             IF       COND(&CCY *NE 'A' *AND &CCY *NE 'B' *AND &CCY +
                          *NE 'H' *AND &CCY *NE 'L') THEN(DO)
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not ''A'', ''B'', +
                         ''H'' or ''L''')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/*/COPY WNCPYSRC,MCC84P004                                           */
/* BSPL SET NO. FIELD ENTRY MANDATORY */
             IF         COND(&RSNO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Blank not a valid entry')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/* BSPL SET NO. MUST BE ON FILE */
             IF         COND(&RSNO *NE 'C') THEN(DO)
             CHGVAR     VAR(&RTCD) VALUE(*MSG)
             IF         COND(&RSNO *EQ '?') THEN(DO)
             CALL       PGM(AORPSTR0) PARM(&RTCD '*KEY' &RSNO &DSFDY)
             GOTO       CMDLBL(ERRMC)
             ENDDO
             CALL       PGM(AORPSTR0) PARM(&RTCD '*KEY' &RSNO &DSFDY)
             IF         COND(&RTCD *NE '       ') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('BSPL Set does not exist +
                          on file')
             GOTO       CMDLBL(ERRMC)
             ENDDO
             ENDDO
/* REPORTING LEVEL */
             IF        COND(&RSLV *LT '1' *OR &RSLV *GT '9') THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not in the range +
                          ''1'' to ''9''')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/**/
/* SHOW BSPL/ A/C CODES */
             IF      COND(&RPCD *NE 'Y' *AND &RPCD *NE 'N') THEN(DO)
             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not ''Y'' or ''N''')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/**/
/* TERM FOR REPORT (1ST COLUMN)*/
             IF         COND(&TERM1 *NE 'P' *AND &TERM1 *NE 'Y' *AND +
                          &TERM1 *NE '1' *AND &TERM1 *NE '2') THEN(DO)
             CHGVAR     VAR(&IN19) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('Entry not ''P'', ''Y'' +
                        ''1'' or ''2''')
             GOTO       CMDLBL(ERRMC)
             ENDDO
 /* VALIDATE TERM 1 EXISTS IF SELECTED */
             IF         COND(&TERM1 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RTCD) VALUE('TERM1  ')
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)
             IF         COND(&RTCD *NE 'TERM1  ') THEN(DO)
             CHGVAR     VAR(&IN19) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('''Term 1'' does not exist')
             GOTO       CMDLBL(ERRMC)
             ENDDO
             ENDDO
 /* VALIDATE TERM 2 EXISTS IF SELECTED */
             IF         COND(&TERM1 *EQ '2') THEN(DO)
             CHGVAR     VAR(&RTCD) VALUE('TERM2  ')
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)
             IF         COND(&RTCD *NE 'TERM2  ') THEN(DO)
             CHGVAR     VAR(&IN19) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('''Term 2'' does not exist')
             GOTO       CMDLBL(ERRMC)
             ENDDO
             ENDDO
/* TERM FOR REPORT (2ND COLUMN)*/
             IF         COND(&TERM2 *NE 'P' *AND &TERM2 *NE 'Y' *AND +
                          &TERM2 *NE '1' *AND &TERM2 *NE '2' *AND +
                          &TERM2 *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN20) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('Entry not ''P'', ''Y'' +
                        ''1'', ''2'' or Blank')
             GOTO       CMDLBL(ERRMC)
             ENDDO
 /* VALIDATE TERM 1 EXISTS IF SELECTED */
             IF         COND(&TERM2 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RTCD) VALUE('TERM1  ')
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)
             IF         COND(&RTCD *NE 'TERM1  ') THEN(DO)
             CHGVAR     VAR(&IN20) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('''Term 1'' does not exist')
             GOTO       CMDLBL(ERRMC)
             ENDDO
             ENDDO
 /* VALIDATE TERM 2 EXISTS IF SELECTED */
             IF         COND(&TERM2 *EQ '2') THEN(DO)
             CHGVAR     VAR(&RTCD) VALUE('TERM2  ')
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)
             IF         COND(&RTCD *NE 'TERM2  ') THEN(DO)
             CHGVAR     VAR(&IN20) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('''Term 2'' does not exist')
             GOTO       CMDLBL(ERRMC)
             ENDDO
             ENDDO
/**/
/* TYPE FOR REPORT */
             IF         COND(&TYPE *NE 'B' *AND &TYPE *NE 'A' *AND +
                             &TYPE *NE 'M') THEN(DO)
             CHGVAR     VAR(&IN21) VALUE('1')
             CHGVAR     VAR(&MSG2) VALUE('Entry not ''B'', ''A'' +
                        ''M''')
             GOTO       CMDLBL(ERRMC)
             ENDDO
/**/
/*  DISPLAY DISPLAY 'ANALYSE BY' SELECTION SCREEN                   */
             CALL       PGM(MC84P) PARM(&GRPCD &RETC &CCY &ANAL)
/**/
             IF         COND(&RETC *EQ 'Y') THEN(GOTO CMDLBL(ERRMC))
             IF         COND(&RETC *EQ 'E') THEN(DO)
                  CHGVAR     VAR(&RCMD) VALUE('E')
                  GOTO       CMDLBL(ENDLBL)
             ENDDO
/**/
/************CHGVAR     VAR(&RPARM) VALUE(&CCY ** &RSNO ** &RSLV ** +
                          &RPCD ** &GRPCD ** &SRPDN ** &TERM1 ** +
                          &TERM2 ** &TYPE ** &ANAL)                                 */ /*BG18886*/
             CHGVAR     VAR(&RPARM) VALUE(&CCY *CAT &RSNO *CAT &RSLV +
                          *CAT &RPCD *CAT &GRPCD *CAT &SRPDN *CAT +
                          &TERM1 *CAT &TERM2 *CAT &TYPE *CAT &ANAL)                    /*BG18886*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDLBL:     ENDPGM