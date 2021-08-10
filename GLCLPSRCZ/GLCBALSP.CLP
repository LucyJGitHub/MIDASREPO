/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Balances Ccy Prompt')                        */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLCBALSP - GL Balances Prompt (called from RCF)            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. CDL087             Date 04May21              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU011             Date 11Mar98              */
/*                      000000             Date DDMmmYY              */
/*                                                                  */
/*-------------------------------------------------------------------*/
/*                                                                    */
/*       CDL087 - Multi Base CCY Spot and Forward Revaluation        */
/*                Upgrade to FM 2.1 2021.A                           */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU011 - EMU Position/Risk Reporting                         */
/*                                                                    */
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
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CEU011) TYPE(*CHAR) LEN(7) VALUE('N')    /*CEU011*/
/*/COPY WNCPYSRC,GLCBALSP04                                          */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU011*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CEU011*/
/*/COPY WNCPYSRC,GLCBALSP05                                          */
             DCL        VAR(&IN06) TYPE(*LGL) LEN(1)                                      /*CDL087*/
             DCL        VAR(&CDL087) TYPE(*CHAR) LEN(7) VALUE('N')                        /*CDL087*/
/**/
             DCLF       FILE(GLCBALSDF) RCDFMT(GLCBALS)
/*/COPY WNCPYSRC,GLCBALSP06                                          */
/**/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)
             RTVJOBA    JOB(&SWSID) USER(&USRID)
/**/                                                                  /*CEU011*/
/** Check if SAR CEU011 is installed */                               /*CEU011*/
/**/                                                                  /*CEU011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU011*/
             CHGVAR     VAR(&SARD) VALUE('CEU011')                    /*CEU011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)  /*CEU011*/
/**/                                                                  /*CEU011*/
/** If CEU011 is installed */                                         /*CEU011*/
/**/                                                                  /*CEU011*/
             IF        COND(&RTCD *EQ '       ') THEN(DO)             /*CEU011*/
               CHGVAR     VAR(&CEU011) VALUE('Y')                     /*CEU011*/
/*/COPY WNCPYSRC,GLCBALSP12                                          */
               CHGVAR     VAR(&IN70) VALUE('1')                       /*CEU011*/
/*/COPY WNCPYSRC,GLCBALSP13                                          */
             ENDDO                                                    /*CEU011*/
/**/                                                                  /*CEU011*/
/** If an error ocurred  */                                           /*CEU011*/
/**/                                                                  /*CEU011*/
             IF        COND((&RTCD *NE '       ') *AND (&RTCD +
                          *NE '*NRF    ')) THEN(DO)                   /*CEU011*/
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                TOMSGQ(MOPERQ)                                        /*CEU011*/
               CHGJOB     SWS('XXXXXX11')                             /*CEU011*/
               GOTO       CMDLBL(ENDLBL)                              /*CEU011*/
             ENDDO                                                    /*CEU011*/
                                                                      /*CEU011*/
/**/                                                                                      /*CDL087*/
/** Check if SAR CDL087 is installed */                                                   /*CDL087*/
/**/                                                                                      /*CDL087*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CDL087*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL087*/
             CHGVAR     VAR(&SARD) VALUE('CDL087')                                        /*CDL087*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)                      /*CDL087*/
/**/                                                                                      /*CDL087*/
/** If CDL087 is installed */                                                             /*CDL087*/
/**/                                                                                      /*CDL087*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL087) VALUE('Y'))                                        /*CDL087*/
/**/                                                                                      /*CDL087*/
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(CHGVAR VAR(&CCY) +
                          VALUE(%SST(&RPARM 1 1)))
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN05) +
                          VALUE('1'))
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN03) +
                          VALUE('1'))
/**/
ERROR:
             SNDRCVF    RCDFMT(GLCBALS)
             CHGVAR     VAR(&IN10) VALUE('0')
/*/COPY WNCPYSRC,GLCBALSP01                                          */
             CHGVAR     VAR(&IN06) VALUE('0')                                             /*CDL087*/
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
             IF         COND(&IN04 *EQ '1') THEN(DO)
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
/*/COPY WNCPYSRC,GLCBALSP02                                          */
/**/                                                                                      /*CDL087*/
             IF        COND(&CDL087 *NE 'Y') THEN(DO)                                     /*CDL087*/
/* CCY MUST BE ONE OF 'B', 'H' OR 'L' */
             IF         COND(&CCY *NE 'B' *AND &CCY +
                          *NE 'H' *AND &CCY *NE 'L') THEN(DO)
/*/COPY WNCPYSRC,GLCBALSP07                                          */
/**/                                                                  /*CEU011*/
/** If CEU011 is installed entry of 'E' is valid. */                  /*CEU011*/
/**/                                                                  /*CEU011*/
               IF         COND((&CEU011 *EQ 'Y' *AND &CCY *NE 'E') +
                          *OR (&CEU011 *EQ 'N')) THEN(DO)             /*CEU011*/
                                                                      /*CEU011*/
/*/COPY WNCPYSRC,GLCBALSP08                                          */
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Entry not ''B'', ''H'' or +
                          ''L''')
/*/COPY WNCPYSRC,GLCBALSP09                                          */
                                                                      /*CEU011*/
/** If CEU011 is installed entry of 'E' is valid. */                  /*CEU011*/
                                                                      /*CEU011*/
                 IF        COND(&CEU011 *EQ 'Y') THEN(CHGVAR +
                  VAR(&MSG) VALUE('Entry not ''B'', ''H'', ''L'' +
                  or ''E'''))                                         /*CEU011*/
/*/COPY WNCPYSRC,GLCBALSP10                                          */
             GOTO       CMDLBL(ERROR)
               ENDDO                                                  /*CEU011*/
/*/COPY WNCPYSRC,GLCBALSP11                                          */
             ENDDO
             ENDDO                                                                        /*CDL087*/
/*/COPY WNCPYSRC,GLCBALSP03                                          */
/**/
             ENDDO
             CHGVAR     VAR(&RPARM) VALUE(&CCY)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDLBL:     ENDPGM
