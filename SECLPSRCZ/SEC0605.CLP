/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Book Position Update')                       */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0605 - BOOK POSITIONS COMPONENT                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 05Feb18              */
/*       Prev Amend No. CSE111             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      246619             Date 28Mar07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSE036             Date 22Apr02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      168141             Date 08Oct99              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      153017             Date 18Nov97             */
/*                      S01408             DATE 11JUL96              */
/*                      S01408             DATE 01FEB96              */
/*                      S01408             DATE 11MAY95              */
/*                      E29207             DATE 08OCT91             */
/*                      E24722             DATE 03APR91             */
/*                      S01189             DATE 07JAN91             */
/*                      E23769             DATE 01OCT90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       CSE111 - Suppress Account Keys on Back-Value of dividends  */
/*       246619 - Clear PF/BKPOPD prior to call on PGM/SE2230.       */
/*       CSE036 - Unrealised Profit and Loss Report by Trade         */
/*       168141 - SEC0605 in loop in COB - can't complete           */
/*       153017 - Add new program written to update file control    */
/*                as fix 112549 removed 'IR' records from BPACHD.   */
/*       S01408 - Addition of core hook SEC0605009                   */
/*       S01408 - Addition of core hook SEC0605001                   */
/*                Addition of core hook SEC0605002                   */
/*                Addition of core hook SEC0605003                   */
/*                Addition of core hook SEC0605004                   */
/*                Addition of core hook SEC0605005                   */
/*                Addition of core hook SEC0605006                   */
/*                Addition of core hook SEC0605007                   */
/*                Addition of core hook SEC0605008                   */
/*                Addition of core hook SEC0605INT                   */
/*                Addition of core hook SEC0605MPE                   */
/*                Addition of core hook SEC0605END                   */
/*       S01408 - Addition of core hook SEC0605MPS                   */
/*       E29207 - DISCOUNT AMORTIZATION                             */
/*       E24722  - OVERRIDE TO LF/SOBTR NOT PF/SOBTRD               */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            *   S01189*/
/*       E23769 - Copy BPACCD & BPACBD Actions to BPACHD            */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/

                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605INT                                          */
                                                                      /*S01408*/
  DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra International +
               Limited 2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MBR)     TYPE(*CHAR)  LEN(1)
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)          * *S01189*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)

/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(79)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/********    DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(3)               * *S01189*/
             DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(1)                /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BRK) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSE036*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSE111*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSE111*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE111*/
             DCL        VAR(&CSE111) TYPE(*CHAR) LEN(1)                                   /*CSE111*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605001                                          */
                                                                      /*S01408*/
                MONMSG MSGID(CPF2817)

             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')             S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605MPS                                          */
                                                                      /*S01408*/
             CHGVAR    VAR(&MBR) VALUE('A')

/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MSG) VALUE('SEC0605 - BOOK +
                          POSITIONS UPDATE')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/*  SET OFF ALL SWITCHES                                            */

             CHGJOB SWS(00000000)

/*  CLEAR OUTPUT FILES                                              */
/*/COPY WNCPYSRC,SEC0605011                                          */

             CLRPFM     FILE(BKPORD)
             CLRPFM     FILE(BKPORA)
             CLRPFM     FILE(BKPHRD)
             CLRPFM     FILE(BKPHRA)
             CLRPFM     FILE(PRFAJD)
             CLRPFM     FILE(PRFAJA)
             CLRPFM     FILE(BKPOPD)                                                      /*246619*/
             CLRPFM     FILE(SEKEYD) MBR(BKPOSNR)
             CLRPFM     FILE(SEKEYA) MBR(BKPOSNR)
             CLRPFM     FILE(SEKEYD) MBR(BKPOSN)
             CLRPFM     FILE(SEKEYA) MBR(BKPOSN)
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE111*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE111*/
             CHGVAR     VAR(&SAR) VALUE('CSE111')                                         /*CSE111*/
             CHGVAR     VAR(&CSE111) VALUE('N')                                           /*CSE111*/
                                                                                          /*CSE111*/
/**  Check if Enhancement is installed */                                                 /*CSE111*/
                                                                                          /*CSE111*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSE111*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSE111*/
             CHGVAR     VAR(&CSE111) VALUE('Y')                                           /*CSE111*/
             ENDDO                                                                        /*CSE111*/
                                                                                          /*CSE111*/
             IF         COND(&CSE111 *EQ 'Y') THEN(DO)                                    /*CSE111*/
             CLRPFM     FILE(SEKEYD) MBR(MMREVAL)                                         /*CSE111*/
             CLRPFM     FILE(SEKEYA) MBR(MMREVAL)                                         /*CSE111*/
             ENDDO                                                                        /*CSE111*/
/**/                                                                                      /*CSE111*/

/*  CHECK FOR COMPONENT RESTART                                     */

/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/

/*  IF RESTART, DISABLE ACCESS PATHS                                */

/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/


/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
/*/COPY WNCPYSRC,SEC0605012                                          */

                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPOSD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACHD) SEQONLY(*YES 1000)
                OVRDBF     FILE(XBPACCD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACBD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKMTHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)

                OVRDBF     FILE(XBKPHDA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBKPOSA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBKPHHA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBPACHA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBPACCA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBPACBA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBKMTHA) SEQONLY(*YES 1)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SEC0605013                                          */


                OVRDBF     FILE(BKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPOSD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHHD) SEQONLY(*YES 100)
                OVRDBF     FILE(BPACHD) SEQONLY(*YES 1000)
                OVRDBF     FILE(BPACCD) SEQONLY(*YES 100)
                OVRDBF     FILE(BPACBD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKMTHD) SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD) SEQONLY(*YES 100)

                OVRDBF     FILE(BKPHDA) SEQONLY(*YES 1)
                OVRDBF     FILE(BKPOSA) SEQONLY(*YES 1)
                OVRDBF     FILE(BKPHHA) SEQONLY(*YES 1)
                OVRDBF     FILE(BPACHA) SEQONLY(*YES 1)
                OVRDBF     FILE(BPACCA) SEQONLY(*YES 1)
                OVRDBF     FILE(BPACBA) SEQONLY(*YES 1)
                OVRDBF     FILE(BKMTHA) SEQONLY(*YES 1)
                OVRDBF     FILE(SNDEVA) SEQONLY(*YES 1)


/*  AND COPY FILES                                                  */
/*/COPY WNCPYSRC,SEC0605014                                          */

                CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDD)
                CPYF       FROMFILE(XBKPHDA) TOFILE(BKPHDA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDA)

                CPYF       FROMFILE(XBKPHHD) TOFILE(BKPHHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHHD)
                CPYF       FROMFILE(XBKPHHA) TOFILE(BKPHHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHHA)

                CPYF       FROMFILE(XBKPOSD) TOFILE(BKPOSD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPOSD)
                CPYF       FROMFILE(XBKPOSA) TOFILE(BKPOSA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPOSA)

                CPYF       FROMFILE(XBPACHD) TOFILE(BPACHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACHD)
                CPYF       FROMFILE(XBPACCD) TOFILE(BPACCD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACCD)
                CPYF       FROMFILE(XBPACBD) TOFILE(BPACBD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACBD)

                CPYF       FROMFILE(XBPACHA) TOFILE(BPACHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACHA)
                CPYF       FROMFILE(XBPACCA) TOFILE(BPACCA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACCA)
                CPYF       FROMFILE(XBPACBA) TOFILE(BPACBA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACBA)

                CPYF       FROMFILE(XBKMTHD) TOFILE(BKMTHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKMTHD)
                CPYF       FROMFILE(XBKMTHA) TOFILE(BKMTHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKMTHA)

                CPYF       FROMFILE(XSNDEVD) TOFILE(SNDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*E20085*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SNDEVD)                       /*E20085*/
                CPYF       FROMFILE(XSNDEVA) TOFILE(SNDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*E20085*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SNDEVA)                       /*E20085*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SEC0605009                                           /*S01408*/
/*                                                                    /*S01408*/

/*  CHANGE DATA AREA TO 'OLD'                                      */

/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/

             ENDDO

/*  ELSE BACKUP FILES                                               */

             ELSE       CMD(DO)

/* DELETE COPY FILES                               */

               DLTF       FILE(XBKPOSD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBKPOSA)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBKPHHD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBKPHHA)
                   MONMSG MSGID(CPF0000)
/*/COPY WNCPYSRC,SEC0605015                                          */
               DLTF       FILE(XBKPHDD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBKPHDA)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBPACHD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBPACHA)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBPACCD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBPACCA)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBPACBD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBPACBA)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBKMTHD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XBKMTHA)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XSNDEVD)
                   MONMSG MSGID(CPF0000)
               DLTF       FILE(XSNDEVA)
                   MONMSG MSGID(CPF0000)

                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605002                                          */
                                                                      /*S01408*/

/*  OVERRIDE TO SEQONLY                                             */
/*/COPY WNCPYSRC,SEC0605016                                          */

                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPOSD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACHD) SEQONLY(*YES 1000)
                OVRDBF     FILE(XBPACCD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACBD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKMTHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)

                OVRDBF     FILE(XBKPHDA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBKPOSA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBKPHHA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBPACHA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBPACCA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBPACBA) SEQONLY(*YES 1)
                OVRDBF     FILE(XBKMTHA) SEQONLY(*YES 1)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SEC0605017                                          */

                OVRDBF     FILE(BKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPOSD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHHD) SEQONLY(*YES 100)
                OVRDBF     FILE(BPACHD) SEQONLY(*YES 1000)
                OVRDBF     FILE(BPACCD) SEQONLY(*YES 100)
                OVRDBF     FILE(BPACBD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKMTHD) SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD) SEQONLY(*YES 100)

                OVRDBF     FILE(BKPHDA) SEQONLY(*YES 1)
                OVRDBF     FILE(BKPOSA) SEQONLY(*YES 1)
                OVRDBF     FILE(BKPHHA) SEQONLY(*YES 1)
                OVRDBF     FILE(BPACHA) SEQONLY(*YES 1)
                OVRDBF     FILE(BPACCA) SEQONLY(*YES 1)
                OVRDBF     FILE(BPACBA) SEQONLY(*YES 1)
                OVRDBF     FILE(BKMTHA) SEQONLY(*YES 1)
                OVRDBF     FILE(SNDEVA) SEQONLY(*YES 1)

/*  AND COPY FILES                                                 */
/*/COPY WNCPYSRC,SEC0605018                                          */

             CPYF       FROMFILE(BKPHDD) TOFILE(&TOLIB/XBKPHDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDD)
             CPYF       FROMFILE(BKPOSD) TOFILE(&TOLIB/XBKPOSD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPOSD)
             CPYF       FROMFILE(BKPHHD) TOFILE(&TOLIB/XBKPHHD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHHD)

             CPYF       FROMFILE(BPACHD) TOFILE(&TOLIB/XBPACHD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACHD)
             CPYF       FROMFILE(BPACCD) TOFILE(&TOLIB/XBPACCD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACCD)
             CPYF       FROMFILE(BPACBD) TOFILE(&TOLIB/XBPACBD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACBD)

             CPYF       FROMFILE(BKPOSA) TOFILE(&TOLIB/XBKPOSA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPOSA)
             CPYF       FROMFILE(BKPHDA) TOFILE(&TOLIB/XBKPHDA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDA)
             CPYF       FROMFILE(BKPHHA) TOFILE(&TOLIB/XBKPHHA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHHA)
             CPYF       FROMFILE(BPACHA) TOFILE(&TOLIB/XBPACHA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACHA)
             CPYF       FROMFILE(BPACCA) TOFILE(&TOLIB/XBPACCA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACCA)
             CPYF       FROMFILE(BPACBA) TOFILE(&TOLIB/XBPACBA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACBA)

             CPYF       FROMFILE(BKMTHD) TOFILE(&TOLIB/XBKMTHD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKMTHD)
             CPYF       FROMFILE(BKMTHA) TOFILE(&TOLIB/XBKMTHA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKMTHA)

             CPYF       FROMFILE(SNDEVD) TOFILE(&TOLIB/XSNDEVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSNDEVD)
             CPYF       FROMFILE(SNDEVA) TOFILE(&TOLIB/XSNDEVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSNDEVA)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605003                                          */
                                                                      /*S01408*/

             ENDDO

/*  CHANGE DATA AREA TO 'NEW'                                       */

/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/

/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MBR) VALUE('A')
             CHGVAR     VAR(&MSG) VALUE('SEC0605A - Reset Book +
                          Positions for Backvaluations')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/*/COPY WNCPYSRC,SEC0605010                                          */

           CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSE036')                        /*CSE036*/
           IF         COND(&RTCD *EQ '       ') THEN(DO)                                  /*CSE036*/

/*    Save a copy of BKPOS before updating for reversals                                  /*CSE036*/

             CPYF       FROMFILE(BKPOSD) TOFILE(SEBKPSVD) +
                          MBROPT(*REPLACE)                                                /*CSE036*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEBKPSVD)                                         /*CSE036*/

/*    Save a copy of BKPHD before updating for reversals                                  /*CSE036*/

             CPYF       FROMFILE(BKPHDD) TOFILE(SEBKHSVD) +
                          MBROPT(*REPLACE)                                                /*CSE036*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEBKHSVD)                                         /*CSE036*/

           ENDDO                                                                          /*CSE036*/

/*  CALL PROGRAM                                                    */

             CALL       PGM(SE2230)

             DLTOVR     FILE(*ALL)

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))

/* SETUP AND SEND PGM MESSAGE                                    */

             CHGVAR     VAR(&MBR) VALUE('B')
             CHGVAR     VAR(&MSG) VALUE('SEC0605B - Generate A/C Keys +
                          - Book Positions - Reversals Since +
                          Backvaluation')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/* SET SWITCH U1 ON TO INDICATE REVERSAL MODE                    */
/* AND SET OFF OTHER SWITCHES                                    */

             CHGJOB SWS(10000000)

/* OVERRIDE FILES                                                */

             OVRDBF     FILE(BPACC) TOFILE(BPACR)
             OVRDBF     FILE(BKPHD) TOFILE(BKPHR)
             OVRDBF     FILE(BKPOS) TOFILE(BKPOR)
             OVRDBF     FILE(BKPHDA) TOFILE(BKPHRA)
             OVRDBF     FILE(BKPOSA) TOFILE(BKPORA)
             OVRDBF     FILE(SECED) TOFILE(SOBSE)
             OVRDBF     FILE(SECEO) TOFILE(SOBSO)
/************OVRDBF     FILE(TRADS) TOFILE(SOBTRD)                      E24722*/
             OVRDBF     FILE(TRADS) TOFILE(SOBTR)                     /*E24722*/
             OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD)  MBR(BKPOSNR)
             OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA)  MBR(BKPOSNR)
             OVRDBF     FILE(HTRACBX) TOFILE(HTRACB) SHARE(*NO)
             OVRDBF     FILE(BPACCU) TOFILE(BPACC) SHARE(*NO)         /*168141*/
/**/                                                                                      /*CSE111*/
             IF         COND(&CSE111 *EQ 'Y') THEN(DO)                                    /*CSE111*/
             OVRDBF     FILE(BPACCL1) TOFILE(BPACRVL1)                                    /*CSE111*/
             OVRDBF     FILE(BPACCU) TOFILE(BPACCL1) SHARE(*NO)                           /*CSE111*/
             CALL       PGM(SE0050)                                                       /*CSE111*/
             GOTO       DUGTAGA                                                           /*CSE111*/
             ENDDO                                                                        /*CSE111*/

/* CALL PROGRAM                                                  */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605004                                          */
                                                                      /*S01408*/
             CALL       PGM(SE2220)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605005                                          */
                                                                      /*S01408*/
DUGTAGA:                                                                                  /*CSE111*/
             DLTOVR     FILE(*ALL)

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))
                                                                                          /*CSE111*/
             IF         COND(&CSE111 *EQ 'Y') THEN(DO)                                    /*CSE111*/
/** Setup and send PGM message */                                                         /*CSE111*/
                                                                                          /*CSE111*/
             CHGJOB SWS(10000000)                                                         /*CSE111*/
             CHGVAR     VAR(&MBR) VALUE('0')                                              /*CSE111*/
             CHGVAR     VAR(&MSG) VALUE('SEC06050 - Dividend +
                          Reversal A/C keys')                                             /*CSE111*/
/**/                                                                                      /*CSE111*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)                            /*CSE111*/
             OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD)  MBR(MMREVAL)                         /*CSE111*/
             OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA)  MBR(MMREVAL)                         /*CSE111*/
                                                                                          /*CSE111*/
/** Call Program */                                                                       /*CSE111*/
                                                                                          /*CSE111*/
             CALL       PGM(SE0051)                                                       /*CSE111*/
                                                                                          /*CSE111*/
             DLTOVR     FILE(*ALL)                                                        /*CSE111*/
                                                                                          /*CSE111*/
/** For Database Errors Recover Data From LDA */                                          /*CSE111*/
                                                                                          /*CSE111*/
             IF     COND(%SWITCH(XXXXXX1X) *OR +
                      (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))                       /*CSE111*/
                                                                                          /*CSE111*/
             ENDDO                                                                        /*CSE111*/
/**/                                                                                      /*CSE111*/

/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MBR) VALUE('C')
             CHGVAR     VAR(&MEM) VALUE('SEC0605C - Delete Reversed +
                          Book Position Actions')

             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/*  SET OFF ALL SWITCHES                                            */

             CHGJOB SWS(00000000)

/*  CALL PROGRAM                                                    */

             IF         COND(&CSE111 *EQ 'Y') THEN(DO)                                    /*CSE111*/
             CALL       PGM(SE0052)                                                       /*CSE111*/
             GOTO       CMDLBL(DUGTG1)                                                    /*CSE111*/
             ENDDO                                                                        /*CSE111*/
                                                                                          /*CSE111*/
             CALL       PGM(SE2240)
                                                                                          /*CSE111*/
 DUGTG1:                                                                                  /*CSE111*/
             DLTOVR     FILE(*ALL)

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))

/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MBR) VALUE('D')
             CHGVAR     VAR(&MSG) VALUE('SEC0605D - Reset Book Positi+
                          ons for Backvaluations')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/*  SET OFF ALL SWITCHES                                            */

             CHGJOB SWS(00000000)

/*  CALL PROGRAM                                                    */

             CALL       PGM(SE2250)

             DLTOVR     FILE(*ALL)

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))

/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MBR) VALUE('E')
             CHGVAR     VAR(&MSG) VALUE('SEC0605E - Generate Coupon +
                          Actions for Back-Valuations')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/*  SET OFF ALL SWITCHES                                            */

             CHGJOB SWS(00000000)

/*  CALL PROGRAM                                                    */

             CALL       PGM(SE2235)

             DLTOVR     FILE(*ALL)

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))

/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MBR) VALUE('F')
             CHGVAR     VAR(&MSG) VALUE('SEC0605F - Generate A/C Keys +
                          - Book Positions - Forward Mode')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/*  CREATE FILE OF RE-ACTIONED HISTORIC TRADES FOR REPORTING        */

             CPYF       FROMFILE(BPACHD) TOFILE(BPACHZ) +
                          MBROPT(*REPLACE) INCREL((*IF RECI *EQ 'D')) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACHZ)

/*  SET OFF ALL SWITCHES                                            */

             CHGJOB SWS(00000000)

/*  OVERRIDE FILES                                                  */

                OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD) MBR(BKPOSN)
                OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA) MBR(BKPOSN)
                OVRDBF     FILE(HTRACBX) TOFILE(HTRACB) SHARE(*NO)
                OVRDBF     FILE(BPACCU) TOFILE(BPACC) SHARE(*NO)      /*168141*/
                                                                      /*S01408*/
             IF         COND(&CSE111 *EQ 'Y') THEN(DO)                                    /*CSE111*/
             OVRDBF     FILE(BPACCU) TOFILE(BPACCL1) SHARE(*NO)                           /*CSE111*/
             CALL       PGM(SE0050)                                                       /*CSE111*/
             GOTO       DUGTAGB                                                           /*CSE111*/
             ENDDO                                                                        /*CSE111*/
                                                                                          /*CSE111*/
/*/COPY WNCPYSRC,SEC0605006                                          */
                                                                      /*S01408*/
             CALL       PGM(SE2220)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605007                                          */
                                                                      /*S01408*/

DUGTAGB:                                                                                  /*CSE111*/
             DLTOVR     FILE(*ALL)

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))

             IF         COND(&CSE111 *EQ 'Y') THEN(DO)                                    /*CSE111*/
/** Setup and send PGM message                                                            /*CSE111*/
                                                                                          /*CSE111*/
             CHGJOB SWS(00000000)                                                         /*CSE111*/
             CHGVAR     VAR(&MBR) VALUE('1')                                              /*CSE111*/
             CHGVAR     VAR(&MSG) VALUE('SEC06051 - Dividend +
                          Forward A/C keys')                                              /*CSE111*/
                                                                                          /*CSE111*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)                            /*CSE111*/
             OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD)  MBR(MMREVAL)                         /*CSE111*/
             OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA)  MBR(MMREVAL)                         /*CSE111*/
                                                                                          /*CSE111*/
/** Call Program */                                                                       /*CSE111*/
                                                                                          /*CSE111*/
             CALL       PGM(SE0051)                                                       /*CSE111*/
                                                                                          /*CSE111*/
             DLTOVR     FILE(*ALL)                                                        /*CSE111*/
                                                                                          /*CSE111*/
/* For Database Errors Recover Data From LDA                     */                       /*CSE111*/
                                                                                          /*CSE111*/
             IF     COND(%SWITCH(XXXXXX1X) *OR +
                      (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))                       /*CSE111*/
                                                                                          /*CSE111*/
             ENDDO                                                                        /*CSE111*/
                                                                                          /*CSE111*/
/*  SETUP AND SEND PGM MESSAGE                                      */

             CHGVAR     VAR(&MBR) VALUE('G')
             CHGVAR     VAR(&MSG) VALUE('SEC0605G - Profit Adjustment +
                          Reconciliation Report')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)


/*  SET OFF ALL SWITCHES                                            */

             CHGJOB SWS(00000000)

/* Preserve data from BPACxD for SE0720 and SE0730              */

                CPYF       FROMFILE(BPACBD) TOFILE(BPACBZ) +
                            MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM BPACBZ)

                CPYF       FROMFILE(BPACCD) TOFILE(BPACCZ) +
                            MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM BPACCZ)

/*  CALL PROGRAM                                                    */

             IF         COND(&CSE111 *EQ 'Y') THEN(DO)                                    /*CSE111*/
             CALL       PGM(SE0053)                                                       /*CSE111*/
             GOTO       CMDLBL(DUGTG2)                                                    /*CSE111*/
             ENDDO                                                                        /*CSE111*/

             CALL       PGM(SE0740)

 DUGTG2:                                                                                  /*CSE111*/
             DLTOVR     FILE(*ALL)

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(GOTO CMDLBL(ERROR))

/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)

/********      CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/

/*  COPY ACTIONS TO BPACHD                                            /*E23769*/
                                                                      /*E23769*/
/*           CPYF       FROMFILE(BPACCD) TOFILE(BPACHD) MBROPT(*ADD) +/*E29207*/
/*                        FMTOPT(*NONE)                   /*E23769*/  /*E29207*/
             CPYF       FROMFILE(BPACCD) TOFILE(BPACHD) MBROPT(*ADD) +
                          INCCHAR(BCRV 1 *NE 'Y') FMTOPT(*NOCHK)      /*E29207*/
             MONMSG     (CPF2817)                                     /*E23769*/
             CPYF       FROMFILE(BPACBD) TOFILE(BPACHD) MBROPT(*ADD) +
                          INCCHAR(BBRI 1 *NE 'Y') FMTOPT(*NOCHK)      /*E23769*/
             MONMSG     (CPF2817)                                     /*E23769*/
                                                                      /*E23769*/
/* */                                                                 /*153017*/
             CALL SE0605                                              /*153017*/
/* */                                                                 /*153017*/
/* CLEAR OUTPUT FILES                                            */

             CLRPFM     FILE(BKPORD)
             CLRPFM     FILE(BKPORA)
             CLRPFM     FILE(BKPHRD)
             CLRPFM     FILE(BKPHRA)
             CLRPFM     FILE(BPACCD)
             CLRPFM     FILE(BPACBD)

/*  CLEAR FILES                                                    */

             DLTF       FILE(XBKPOSD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBKPOSA)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBKPHHD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBKPHHA)
                 MONMSG MSGID(CPF0000)
/*/COPY WNCPYSRC,SEC0605019                                          */
             DLTF       FILE(XBKPHDD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBKPHDA)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBPACHD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBPACHA)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBPACCD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBPACCA)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBPACBD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBPACBA)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBKMTHD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XBKMTHA)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XSNDEVD)
                 MONMSG MSGID(CPF0000)
             DLTF       FILE(XSNDEVD)
                 MONMSG MSGID(CPF0000)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605008                                          */
                                                                      /*S01408*/
             ENDDO
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605MPE                                          */
                                                                      /*S01408*/

/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */

 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0605' *TCAT &MBR *TCAT +
                          ' - Job Terminated, Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO

/*  FOR FILE CONTROLS OUT OF BALANCE ERROR                          */

             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE('SEC0605' *TCAT &MBR *TCAT +
                          ' - File Controls Out Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO

/*ENDPGM:*****ENDPGM                                                 * *S01117*/
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0605END                                          */
                                                                      /*S01408*/
             ENDPGM                                                   /*S01117*/
