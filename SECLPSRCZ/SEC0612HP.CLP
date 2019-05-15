/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Outstanding Trade Settlements Req')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0612HP - OUTSTANDING TRADE SETTLEMENTS REQUEST          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 20May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 16Jan91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes                         */
/*       S01117 - MULTIBRANCHING   NEW PROGRAM REPLACING SEC0612HL  */
/*                                 AND SEC0612HR                    */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS1) TYPE(*DEC) LEN(3)
             DCL        VAR(&DAYS2) TYPE(*DEC) LEN(3)
             DCL        VAR(&DAYS1A) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DAYS2A) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&IN02) TYPE(*LGL)
             DCL        VAR(&IN03) TYPE(*LGL)
             DCL        VAR(&IN04) TYPE(*LGL)
             DCL        VAR(&IN05) TYPE(*LGL)
             DCL        VAR(&IN99) TYPE(*LGL)
             DCL        VAR(&WSIDL) TYPE(*CHAR) LEN(3)
             DCL        &WSID  *CHAR 10
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
 
             DCLF       FILE(SEC612HDF) RCDFMT(SEC612)
 
/**/
/* GET SCREEN VARIABLES AND DISPLAY PROMPT SCREEN */
/**/
             RTVJOBA  JOB(&WSID)
             CHGVAR     VAR(&WSIDL) VALUE(%SST(&WSID 1 3 ))
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)
             CHGVAR     VAR(&OPTION) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&DAYS1A) VALUE(%SST(&RPARM 2 3))
             CHGVAR     VAR(&DAYS2A) VALUE(%SST(&RPARM 5 3))
             CHGVAR     VAR(&DAYS1) VALUE(&DAYS1A)
             CHGVAR     VAR(&DAYS2) VALUE(&DAYS2A)
             ENDDO
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN13) +
                          VALUE('1'))
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN11) +
                          VALUE('1'))
 
ERROR:       SNDRCVF    RCDFMT(SEC612)
             CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
/* IF F3, RETURN TO RCF WITH ACTION CODE = END                       */
             IF         COND(&IN99 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('E')
             GOTO       CMDLBL(RETURN)
             ENDDO
/* IF F12, RETURN TO RCF WITH ACTION CODE = FIRST SCREEN             */
             IF         COND(&IN12 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('F')
             GOTO       CMDLBL(RETURN)
             ENDDO
/* IF F10, RETURN TO RCF WITH ACTION CODE = DELETE                   */
             IF         COND(*IN10 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('D')
             GOTO       CMDLBL(RETURN)
             ENDDO
/* CHECK VALIDATION ONLY WHEN NOT ENQUIRY OR DELETE */
             IF         COND(&IN11 *EQ '0' *AND &IN13 *EQ '0') THEN(DO)
/**********  IF         COND((&OPTION *= '1') *AND (&OPTION *= '2') +             */ /*BG18886*/
/**********               *AND (&OPTION *= '3') *AND (&OPTION *= +                */ /*BG18886*/
/**********               '4')) THEN(DO)                                          */ /*BG18886*/
             IF         COND((&OPTION *NE '1') *AND (&OPTION *NE '2') +
                          *AND (&OPTION *NE '3') *AND (&OPTION *NE +
                          '4')) THEN(DO)                                             /*BG18886*/
             CHGVAR     VAR(&IN05) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
             IF         COND(&OPTION = '1') THEN(DO)
/**********  IF         COND(&DAYS1 *= 0) THEN(DO)                                */ /*BG18886*/
             IF         COND(&DAYS1 *NE 0) THEN(DO)                                  /*BG18886*/
                       CHGVAR     VAR(&IN01) VALUE('1')
                       GOTO       CMDLBL(ERROR)
                       ENDDO
 
/**********  IF         COND(&DAYS2 *= 0) THEN(DO)                                */ /*BG18886*/
             IF         COND(&DAYS2 *NE 0) THEN(DO)                                  /*BG18886*/
             CHGVAR     VAR(&IN02) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
/**********  IF         COND((&OPTION = '3') * (&OPTION = '2')) +                */ /*BG18886*/
/**********               THEN(DO)                                               */ /*BG18886*/
             IF         COND((&OPTION = '3') *OR (&OPTION = '2')) +
                          THEN(DO)                                                  /*BG18886*/
             IF         COND(&DAYS1 < 1) THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**********  IF         COND(&DAYS2 *= 0) THEN(DO)                                */ /*BG18886*/
             IF         COND(&DAYS2 *NE 0) THEN(DO)                                  /*BG18886*/
             CHGVAR     VAR(&IN02) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             IF         COND(&OPTION = '4') THEN(DO)
             IF         COND(&DAYS2 >= &DAYS1) THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             CHGVAR     VAR(&DAYS1A) VALUE(&DAYS1)
             CHGVAR     VAR(&DAYS2A) VALUE(&DAYS2)
 
 
/**********  CHGVAR     VAR(&RPARM) VALUE(&OPTION ** &DAYS1A ** +                     */ /*BG18886*/
/**********               &DAYS2A)                                                    */ /*BG18886*/
             CHGVAR     VAR(&RPARM) VALUE(&OPTION *CAT &DAYS1A *CAT +
                          &DAYS2A)                                                      /*BG18886 */
             ENDDO
 
RETURN:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
