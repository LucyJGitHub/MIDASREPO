/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL BSPL Prompt')                                */
/********************************************************************/
/*                                                                  */
/*       Midas General Ledger Module                                */
/*                                                                  */
/*       GLC86P - BSPL Prompt (rewritten)                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD023170           Date 31Oct13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      194565             Date 17Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      149862             Date 24Dec98              */
/*                      CEU011             Date 11Mar98              */
/*                      S01408             Date 04Aug95              */
/*                      S01408             Date 10Apr95              */
/*                      081870             DATE  19JAN95            */
/*                      054315             DATE  26APR93            */
/*                      S10736             DATE  28OCT92            */
/*                      E28177             DATE  06SEP91            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       MD023170 - Error on IC request for BSPL report             */
/*       BG18886 - Amend non-standard codes.                        */
/*       194565 - Removing 149862 from this program so if requested */
/*                a report with report account code = 'N' can be    */
/*                produced.                                         */
/*       149862 - If Selected Currency is E (for Consolidated Euro) */
/*                Report Account Code should be 'Y' as 'N' option   */
/*                will produce an erroneous Consolidated Euro rpt   */
/*       CEU011 - EMU Position/Risk Reporting                       */
/*       S01408  -  CORE HOOK ADDED GLC86PINT                       */
/*               -  CORE HOOK ADDED GLC86PMPS                       */
/*               -  CORE HOOK ADDED GLC86P001                       */
/*       S01408  -  CORE HOOK ADDED GLC86PMP1                       */
/*               -  CORE HOOK ADDED GLC86PMP2                       */
/*               -  CORE HOOK ADDED GLC86PMP3                       */
/*               -  CORE HOOK ADDED GLC86PMPE                       */
/*       081870  -  Management A/c Screen Show when module off      */
/*       054315  -  Selections Not redisplayed for verification     */
/*       S10736  -  Add new screen for Management Accounts          */
/*       E28177  -  Add Option to print Zero Balances               */
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
             DCL        VAR(&SRCE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ROUD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ZERO) TYPE(*CHAR) LEN(1)                 /*E28177*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
/*           DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)              */ /*S10736*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MCON) TYPE(*CHAR) LEN(1)                 /*S10736*/
             DCL        VAR(&RETC) TYPE(*CHAR) LEN(1)                 /*S10736*/
             DCL        VAR(&ANAL) TYPE(*CHAR) LEN(9)                 /*S10736*/
             DCL        VAR(&PERSET) TYPE(*CHAR) LEN(1)               /*S10736*/
             DCL        VAR(&RPDN) TYPE(*DEC) LEN(3 0)                /*S10736*/
             DCL        VAR(&IN66) TYPE(*LGL) LEN(1)                  /*S10736*/
/*/COPY WNCPYSRC,GLC86P019                                           */
             DCL        VAR(&CEU011) TYPE(*CHAR) LEN(7) VALUE('N')    /*CEU011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU011*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86PINT                                           */
                                                                      /*S01408*/
/**/
/*********** DCLF       FILE(GLC86DF) RCDFMT(GLC86)                   /*S10736*/
             DCLF       FILE(GLC86DF) RCDFMT(GLC86 GLC86MC)           /*S10736*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86PMPS                                           */
                                                                      /*S01408*/
/**/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)
/************RTVJOBA    JOB(&SWSID)                                   /*054315*/
             RTVJOBA    JOB(&SWSID) USER(&SUSER)                      /*054315*/
/*/COPY WNCPYSRC,GLC86P013                                           */
/**/                                                                  /*CEU011*/
/** Check if SAR CEU011 is installed */                               /*CEU011*/
/**/                                                                  /*CEU011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU011*/
             CHGVAR     VAR(&SARD) VALUE('CEU011')                    /*CEU011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)  /*CEU011*/
/**/                                                                  /*CEU011*/
/** If CEU011 is installed */                                         /*CEU011*/
/**?                                                                  /*CEU011*/
             IF        COND(&RTCD *EQ '       ') THEN(DO)             /*CEU011*/
               CHGVAR     VAR(&CEU011) VALUE('Y')                     /*CEU011*/
/*/COPY WNCPYSRC,GLC86P021                                           */
               CHGVAR     VAR(&IN70) VALUE('1')                       /*CEU011*/
/*/COPY WNCPYSRC,GLC86P022                                           */
             ENDDO                                                    /*CEU011*/
/**/                                                                  /*CEU011*/
/** If an error ocurred  */                                           /*CEU011*/
/**/                                                                  /*CEU011*/
             IF         COND((&RTCD *NE '       ') *AND (&RTCD *NE +
                          '*NRF    ')) THEN(DO)                       /*CEU011*/
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                TOMSGQ(MOPERQ)                                        /*CEU011*/
               CHGJOB     SWS('XXXXXX11')                             /*CEU011*/
               GOTO       CMDLBL(ENDLBL)                              /*CEU011*/
             ENDDO                                                    /*CEU011*/
                                                                      /*CEU011*/
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&RSNO) VALUE(%SST(&RPARM 2 1))
             CHGVAR     VAR(&RSLV) VALUE(%SST(&RPARM 3 1))
             CHGVAR     VAR(&RPCD) VALUE(%SST(&RPARM 4 1))
             CHGVAR     VAR(&SRCE) VALUE(%SST(&RPARM 5 1))
             CHGVAR     VAR(&ROUD) VALUE(%SST(&RPARM 6 1))
             CHGVAR     VAR(&ZERO) VALUE(%SST(&RPARM 7 1))            /*E28177*/
             CHGVAR     VAR(&GRPCD) VALUE(%SST(&RPARM 8 2))           /*S10736*/
             CHGVAR     VAR(&SRPDN) VALUE(%SST(&RPARM 10 4))          /*S10736*/
             CHGVAR     VAR(&TERM) VALUE(%SST(&RPARM 14 1))           /*S10736*/
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 15 1))           /*S10736*/
             CHGVAR     VAR(&ANAL) VALUE(%SST(&RPARM 16 9))           /*S10736*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86PMP1                                           */
                                                                      /*S01408*/
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&RSLV) VALUE('9')
             CHGVAR     VAR(&RPCD) VALUE('Y')
             CHGVAR     VAR(&SRCE) VALUE('Y')
             CHGVAR     VAR(&ZERO) VALUE('Y')                         /*E28177*/
             CHGVAR     VAR(&ANAL) VALUE('*')                         /*054315*/
             ENDDO
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN05) +
                          VALUE('1'))
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN03) +
                          VALUE('1'))
/*/COPY WNCPYSRC,GLC86P020                                           */
/**/                                                                  /*S10736*/
/*  DETERMINE IF MANAGEMENT ACCOUNTS MODULE IS SWITCHED ON  */        /*S10736*/
/*  IN SDMMODPD POSITION 95 */                                        /*S10736*/
             CHGVAR     VAR(&RTCD) VALUE('*DBERR ')                   /*S10736*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &DSFDY)     /*S10736*/
             CHGVAR VAR(&MCON) VALUE(%SST(&DSFDY 95 1))               /*S10736*/
/**/                                                                  /*S10736*/
/*  IF THE MANAGEMENT ACCOUNTS MODULE IS NOT SWITCHED ON  */          /*S10736*/
             IF         COND(&MCON *NE 'Y') THEN(DO)                  /*S10736*/
/**/
ERROR:
             SNDRCVF    RCDFMT(GLC86)
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN14) VALUE('0')
             CHGVAR     VAR(&IN15) VALUE('0')
             CHGVAR     VAR(&IN16) VALUE('0')                         /*E28177*/
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
/* CHECK VALIDATION ONLY WHEN NOT ENQUIRY OR DELETE */
             IF         COND(&IN03 *EQ '0' *AND &IN05 *EQ '0') THEN(DO)
/* CCY FIELD ENTRY MANDATORY */
             IF         COND(&CCY *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Blank not a valid entry')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,GLC86P003                                           */
/* CCY MUST BE ONE OF 'A', 'B', 'H' OR 'L' */
             IF         COND(&CCY *NE 'A' *AND &CCY *NE 'B' *AND &CCY +
                          *NE 'H' *AND &CCY *NE 'L') THEN(DO)
/*/COPY WNCPYSRC,GLC86P015                                           */
/**/                                                                  /*CEU011*/
/** If CEU011 is installed entry of 'E' is valid. */                  /*CEU011*/
/**/                                                                  /*CEU011*/
               IF         COND((&CEU011 *EQ 'Y' *AND &CCY *NE 'E') +
                          *OR (&CEU011 *EQ 'N')) THEN(DO)             /*CEU011*/
/*/COPY WNCPYSRC,GLC86P007                                           */
             CHGVAR     VAR(&IN10) VALUE('1')
/*/COPY WNCPYSRC,GLC86P008                                           */
             CHGVAR     VAR(&MSG) VALUE('Entry not ''A'', ''B'', +
                         ''H'' or ''L''')
/*/COPY WNCPYSRC,GLC86P016                                           */
/**/                                                                  /*CEU011*/
/** If CEU011 is installed entry of 'E' is valid. */                  /*CEU011*/
/**/                                                                  /*CEU011*/
                 IF         COND(&CEU011 *EQ 'Y') THEN(CHGVAR +
                            VAR(&MSG) VALUE('Entry not ''A'', ''B'', +
                            ''H'', ''L'' or ''E'''))                  /*CEU011*/
/*/COPY WNCPYSRC,GLC86P009                                           */
             GOTO       CMDLBL(ERROR)
               ENDDO                                                  /*CEU011*/
             ENDDO
/*/COPY WNCPYSRC,GLC86P004                                           */
/* BSPL SET NO. FIELD ENTRY MANDATORY */
             IF         COND(&RSNO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Blank not a valid entry')
             GOTO       CMDLBL(ERROR)
             ENDDO
/* BSPL SET NO. MUST BE ON FILE */
             IF         COND(&RSNO *NE 'C') THEN(DO)
/*           CHGVAR     VAR(&OPTN) VALUE(*KEY)                     */ /*S10736*/
             CHGVAR     VAR(&RTCD) VALUE(*MSG)
             IF         COND(&RSNO *EQ '?') THEN(DO)
/*          CALL       PGM(AORPSTR0) PARM(&RTCD &OPTN &RSNO &DSFDY)*/ /*S10736*/
             CALL       PGM(AORPSTR0) PARM(&RTCD '*KEY' &RSNO &DSFDY) /*S10736*/
             GOTO       CMDLBL(ERROR)
             ENDDO
/*          CALL       PGM(AORPSTR0) PARM(&RTCD &OPTN &RSNO &DSFDY)*/ /*S10736*/
             CALL       PGM(AORPSTR0) PARM(&RTCD '*KEY' &RSNO &DSFDY) /*S10736*/
             IF         COND(&RTCD *NE '       ') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('BSPL Set does not exist +
                          on file')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,GLC86P014                                           */
             ENDDO
/* REPORTING LEVEL */
             IF         COND(&RSLV *LT '1' *OR &RSLV *GT '9') THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not in the range +
                          ''1'' to ''9''')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/
/* SHOW BSPL/ A/C CODES */
             IF         COND(&RPCD *NE 'Y' *AND &RPCD *NE 'N') THEN(DO)
             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not ''Y'' or ''N''')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/                                                                   /*149862*/
/**********  IF     COND(&RPCD *NE 'Y' *AND &CCY *EQ 'E') THEN(DO) */              /*149862 194565*/
/**********  CHGVAR     VAR(&IN13) VALUE('1') */                                   /*149862 194565*/
/**********  CHGVAR     VAR(&MSG) VALUE('Entry must be ''Y'' if + */
/**********               Currency Selected is ''E''') */                          /*149862 194565*/
/**********  GOTO       CMDLBL(ERROR) */                                           /*149862 194565*/
/**********  ENDDO */                                                              /*149862 194565*/
/**/
/* SOURCE FOR REPORT */
             IF         COND(&SRCE *NE 'Y' *AND &SRCE *NE 'D') THEN(DO)
             CHGVAR     VAR(&IN14) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not ''Y'' or ''D''')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/
/* ROUNDING */
             IF         COND(&ROUD *NE 'U' *AND &ROUD *NE 'T' *AND +
                             &ROUD *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN15) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not ''U'', ''T'', +
                          or Blank')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/
/* PRINT ZERO BALANCES */                                             /*E28177*/
             IF         COND(&ZERO *NE 'N' *AND &ZERO *NE 'Y') +
                          THEN(DO)                                    /*E28177*/
             CHGVAR     VAR(&IN16) VALUE('1')                         /*E28177*/
             CHGVAR     VAR(&MSG) VALUE('Entry not ''Y'' or ''N''')   /*E28177*/
             GOTO       CMDLBL(ERROR)                                 /*E28177*/
             ENDDO                                                    /*E28177*/
/*/COPY WNCPYSRC,GLC86P023                                           */
/**/                                                                  /*E28177*/
/************CHGVAR     VAR(&RPARM) VALUE(&CCY ** &RSNO ** &RSLV +
                            ** &RPCD ** &SRCE ** &ROUD)*************/ /*E28177*/
/**********  CHGVAR     VAR(&RPARM) VALUE(&CCY ** &RSNO ** &RSLV +
                            ** &RPCD ** &SRCE ** &ROUD ** &ZERO)              /*E28177*/ /*BG18886*/
             CHGVAR     VAR(&RPARM) VALUE(&CCY *CAT &RSNO *CAT &RSLV +
                            *CAT &RPCD *CAT &SRCE *CAT &ROUD *CAT &ZERO)      /*E28177*/ /*BG18886*/
/*/COPY WNCPYSRC,GLC86P024                                           */
/**/
             ENDDO
/**/                                                                  /*S10736*/
             ENDDO                                                    /*S10736*/
             ELSE       CMD(DO)                                       /*081870*/
/**/                                                                  /*S10736*/
/* Blank Souce of Posting if Management Accounts Present */           /*S10736*/
/**/                                                                  /*S10736*/
             IF         COND(&MCON *EQ 'Y') THEN(CHGVAR VAR(&SRCE) +
                          VALUE(' '))                                 /*S10736*/
/**/                                                                  /*S10736*/
/**/                                                                  /*S10736*/
ERRMC:                                                                /*S10736*/
             SNDRCVF    RCDFMT(GLC86MC)                               /*S10736*/
             CHGVAR     VAR(&IN10) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN11) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN12) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN13) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN14) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN15) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN16) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN17) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN18) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN19) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN20) VALUE('0')                         /*S10736*/
             CHGVAR     VAR(&IN66) VALUE('0')                         /*S10736*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86PMP2                                           */
                                                                      /*S01408*/
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
/* CHECK VALIDATION ONLY WHEN NOT ENQUIRY OR DELETE */
             IF         COND(&IN03 *EQ '0' *AND &IN05 *EQ '0') THEN(DO)
/* CONTROL GROUP MUST BE ON FILE */                                   /*S10736*/
             IF         COND(&GRPCD *NE '  ') THEN(DO)                /*S10736*/
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &GRPCD +
                          &DSFDY)                                     /*S10736*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S10736*/
             CHGVAR     VAR(&IN17) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('Control Group does not +
                          exist on file')                             /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
             CHGVAR VAR(&PERSET) VALUE(%SST(&DSFDY 33 1))             /*S10736*/
             ENDDO                                                    /*S10736*/
/* RELATIVE PERIOD MUST BE BLANK IF CONTROL GROUP IS BLANK         */ /*S10736*/
             IF         COND((&GRPCD *EQ '  ') *AND (&SRPDN *NE +
                        '    ')) THEN(DO)                             /*S10736*/
             CHGVAR     VAR(&IN18) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('Relative Period must be +
                        blank if Control Group is blank')             /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/* RELATIVE PERIOD MUST BE ENTERED IF CONTROL GROUP IS ENTERED  */    /*S10736*/
             IF         COND((&GRPCD *NE '  ') *AND (&SRPDN *EQ +
                        '    ')) THEN(DO)                             /*S10736*/
             CHGVAR     VAR(&IN18) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('Relative Period must be +
                        entered if Control Group is entered')         /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/* RELATIVE PERIOD MUST EXIST FOR CONTROL GROUP SELECTED OR BE '0' */ /*S10736*/
             CHGVAR     VAR(&RPDN) VALUE(&SRPDN)                      /*S10736*/
             MONMSG     MSGID(CPF0818) EXEC(DO)
             CHGVAR     VAR(&IN66) VALUE('1')
             GOTO       CMDLBL(SKIP)
             ENDDO                                                    /*S10736*/
             IF         COND(&SRPDN *NE '   ') THEN(DO)               /*S10736*/
             CHGVAR     VAR(&SRPDN) VALUE(&RPDN)                      /*S10736*/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)                               /*S10736*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S10736*/
             CHGVAR     VAR(&IN18) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('Relative Period does not +
                          exist for this Control Group')              /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
             ENDDO                                                    /*S10736*/
SKIP:                                                                 /*S10736*/
             IF         COND((&GRPCD *NE '   ') *AND (&IN66 *EQ +
                          '1')) THEN(DO)
             CHGVAR     VAR(&IN18) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('Relative Period must be +
                          blank or a numeric value')                  /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/* CCY FIELD ENTRY MANDATORY */                                       /*S10736*/
             IF         COND(&CCY *EQ ' ') THEN(DO)                   /*S10736*/
             CHGVAR     VAR(&IN10) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG) VALUE('Blank not a valid entry')    /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/*/COPY WNCPYSRC,GLC86P005                                           */
/* CCY MUST BE ONE OF 'A', 'B', 'H' OR 'L' */                         /*S10736*/
             IF       COND(&CCY *NE 'A' *AND &CCY *NE 'B' *AND &CCY +
                          *NE 'H' *AND &CCY *NE 'L') THEN(DO)         /*S10736*/
/*/COPY WNCPYSRC,GLC86P017                                           */
/**/                                                                  /*CEU011*/
/** If CEU011 is installed entry of 'E' is valid. */                  /*CEU011*/
/**/                                                                  /*CEU011*/
               IF         COND((&CEU011 *EQ 'Y' *AND &CCY *NE 'E') +
                          *OR (&CEU011 *EQ 'N')) THEN(DO)             /*CEU011*/
/*/COPY WNCPYSRC,GLC86P010                                           */
             CHGVAR     VAR(&IN10) VALUE('1')                         /*S10736*/
/*/COPY WNCPYSRC,GLC86P011                                           */
             CHGVAR     VAR(&MSG) VALUE('Entry not ''A'', ''B'', +
                         ''H'' or ''L''')                             /*S10736*/
/*/COPY WNCPYSRC,GLC86P018                                           */
/**/                                                                  /*CEU011*/
/** If CEU011 is installed entry of 'E' is valid. */                  /*CEU011*/
/**/                                                                  /*CEU011*/
                 IF        COND(&CEU011 *EQ 'Y') THEN(CHGVAR +
                           VAR(&MSG) VALUE('Entry not ''A'', ''B'', +
                           ''H'', ''L'' or ''E'''))                   /*CEU011*/
/*/COPY WNCPYSRC,GLC86P012                                           */
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
               ENDDO                                                  /*CEU011*/
             ENDDO                                                    /*S10736*/
/*/COPY WNCPYSRC,GLC86P006                                           */
/* BSPL SET NO. FIELD ENTRY MANDATORY */                              /*S10736*/
             IF         COND(&RSNO *EQ ' ') THEN(DO)                  /*S10736*/
             CHGVAR     VAR(&IN11) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG) VALUE('Blank not a valid entry')    /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/* BSPL SET NO. MUST BE ON FILE */                                    /*S10736*/
             IF         COND(&RSNO *NE 'C') THEN(DO)                  /*S10736*/
             CHGVAR     VAR(&RTCD) VALUE(*MSG)                        /*S10736*/
             IF         COND(&RSNO *EQ '?') THEN(DO)                  /*S10736*/
             CALL       PGM(AORPSTR0) PARM(&RTCD '*KEY' &RSNO &DSFDY) /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
             CALL       PGM(AORPSTR0) PARM(&RTCD '*KEY' &RSNO &DSFDY) /*S10736*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S10736*/
             CHGVAR     VAR(&IN11) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG) VALUE('BSPL Set does not exist +
                          on file')                                   /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
             ENDDO                                                    /*S10736*/
/* REPORTING LEVEL */                                                 /*S10736*/
             IF        COND(&RSLV *LT '1' *OR &RSLV *GT '9') THEN(DO) /*S10736*/
             CHGVAR     VAR(&IN12) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG) VALUE('Entry not in the range +
                          ''1'' to ''9''')                            /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/**/                                                                  /*S10736*/
/* SHOW BSPL/ A/C CODES */                                            /*S10736*/
             IF      COND(&RPCD *NE 'Y' *AND &RPCD *NE 'N') THEN(DO)  /*S10736*/
             CHGVAR     VAR(&IN13) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG) VALUE('Entry not ''Y'' or ''N''')   /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/**/                                                                   /*149862*/
/**********  IF     COND(&RPCD *NE 'Y' *AND &CCY *EQ 'E') THEN(DO) */              /*149862 194565*/
/**********  CHGVAR     VAR(&IN13) VALUE('1') */                                   /*149862 194565*/
/**********  CHGVAR     VAR(&MSG) VALUE('Entry must be ''Y'' if + */
/**********               Currency Selected is ''E''') */                          /*149862 194565*/
/**********  GOTO       CMDLBL(ERRMC) */                                           /*149862 194565*/
/**********  ENDDO */                                                              /*149862 194565*/
/**/                                                                  /*S10736*/
/* IF CONTROL GROUP IS ENTERED */                                     /*S10736*/
             IF         COND(&GRPCD *NE '  ') THEN(DO)                /*S10736*/
/* TERM FOR REPORT */                                                 /*S10736*/
             IF         COND(&TERM *NE 'D' *AND &TERM *NE 'Y' *AND +
                         &TERM *NE '1' *AND &TERM *NE '2') THEN(DO)   /*S10736*/
             CHGVAR     VAR(&IN19) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('Entry not ''D'', ''Y'' +
                        ''1'' or ''2''')                              /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
 /* VALIDATE TERM 1 EXISTS IF SELECTED */                             /*S10736*/
             IF         COND(&TERM *EQ '1') THEN(DO)                  /*S10736*/
             CHGVAR     VAR(&RTCD) VALUE('TERM1  ')                   /*S10736*/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)                               /*S10736*/
             IF         COND(&RTCD *NE 'TERM1  ') THEN(DO)            /*S10736*/
             CHGVAR     VAR(&IN19) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('''Term 1'' does not exist') /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
             ENDDO                                                    /*S10736*/
 /* VALIDATE TERM 2 EXISTS IF SELECTED */                             /*S10736*/
             IF         COND(&TERM *EQ '2') THEN(DO)                  /*S10736*/
             CHGVAR     VAR(&RTCD) VALUE('TERM2  ')                   /*S10736*/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PERSET +
                          &RPDN &DSFDY)                               /*S10736*/
             IF         COND(&RTCD *NE 'TERM2  ') THEN(DO)            /*S10736*/
             CHGVAR     VAR(&IN19) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('''Term 2'' does not exist') /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
             ENDDO                                                    /*S10736*/
/**/                                                                  /*S10736*/
/* TYPE FOR REPORT */                                                 /*S10736*/
             IF         COND(&TYPE *NE 'B' *AND &TYPE *NE 'A' *AND +
                             &TYPE *NE 'M') THEN(DO)                  /*S10736*/
             CHGVAR     VAR(&IN20) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG2) VALUE('Entry not ''B'', ''A'' +
                        ''M''')                                       /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/* ELSE CONTROL GROUP NOT ENTERED*/                                   /*S10736*/
             ENDDO                                                    /*S10736*/
             ELSE       CMD(DO)                                       /*S10736*/
             IF      COND(&TERM *EQ 'D' *AND &TYPE *EQ 'M') THEN(DO)  /*S10736*/
             GOTO       CMDLBL(OKAY)                                  /*S10736*/
             ENDDO                                                    /*S10736*/
             IF      COND(&TERM *EQ 'Y' *AND &TYPE *EQ 'B') THEN(DO)  /*S10736*/
             GOTO       CMDLBL(OKAY)                                  /*S10736*/
             ENDDO                                                    /*S10736*/
             CHGVAR     VAR(&IN19) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&IN20) VALUE('1')                                           /*MD023170*/
             CHGVAR     VAR(&MSG2) VALUE('If Control Group is not ent+
                          ered Term and Type must be ''D'' & ''M'' or +
                          ''Y'' & ''B''')                             /*S10736*/
/*/COPY WNCPYSRC,GLC86P002                                           */
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
 OKAY:                                                                /*S10736*/
/**/                                                                  /*S10736*/
             ENDDO                                                    /*S10736*/
/**/                                                                  /*S10736*/
/* ROUNDING */                                                        /*S10736*/
             IF         COND(&ROUD *NE 'U' *AND &ROUD *NE 'T' *AND +
                             &ROUD *NE ' ') THEN(DO)                  /*S10736*/
             CHGVAR     VAR(&IN15) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG) VALUE('Entry not ''U'', ''T'', +
                          or Blank')                                  /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
/**/                                                                  /*S10736*/
/* PRINT ZERO BALANCES */                                             /*S10736*/
             IF         COND(&ZERO *NE 'N' *AND &ZERO *NE 'Y') +
                          THEN(DO)                                    /*S10736*/
             CHGVAR     VAR(&IN16) VALUE('1')                         /*S10736*/
             CHGVAR     VAR(&MSG) VALUE('Entry not ''Y'' or ''N''')   /*S10736*/
             GOTO       CMDLBL(ERRMC)                                 /*S10736*/
             ENDDO                                                    /*S10736*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86PMP3                                           */
                                                                      /*S01408*/
/**/                                                                  /*S10736*/
/*  IF CONTROL GROUP IS ENTERED DISPLAY DISPLAY 'ANALYSE BY' */       /*S10736*/
/*  SELECTION SCREEN  */                                              /*S10736*/
             IF         COND(&GRPCD *NE '  ') THEN(DO)                /*S10736*/
             CALL       PGM(MC86P) PARM(&GRPCD &RETC &CCY &ANAL)      /*S10736*/
             IF         COND(&RETC *EQ 'Y') THEN(GOTO CMDLBL(ERRMC))  /*S10736*/
             IF         COND(&RETC *EQ 'E') THEN(DO)                  /*054315*/
                  CHGVAR     VAR(&RCMD) VALUE('E')                    /*054315*/
                  GOTO       CMDLBL(ENDLBL)                           /*054315*/
             ENDDO                                                    /*054315*/
             ENDDO
/*/COPY WNCPYSRC,GLC86P025                                           */
/**********  CHGVAR     VAR(&RPARM) VALUE(&CCY ** &RSNO ** &RSLV +
                            ** &RPCD ** &SRCE ** &ROUD ** &ZERO +
                            ** &GRPCD ** &SRPDN ** &TERM ** &TYPE +
                            ** &ANAL)                                         /*S10736*/ /*BG18886*/
             CHGVAR     VAR(&RPARM) VALUE(&CCY *CAT &RSNO *CAT &RSLV +
                          *CAT &RPCD *CAT &SRCE *CAT &ROUD *CAT +
                          &ZERO *CAT &GRPCD *CAT &SRPDN *CAT &TERM +
                          *CAT &TYPE *CAT &ANAL)                              /*S10736*/ /*BG18886*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86PMPE                                           */
                                                                      /*S01408*/
/**/                                                                  /*S10736*/
             ENDDO                                                    /*S10736*/
             ENDDO                                                    /*081870*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC86P001                                           */
                                                                      /*S01408*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDLBL:     ENDPGM
