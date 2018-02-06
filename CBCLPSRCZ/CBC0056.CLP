/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Set up COB parm frm rep/comp parm')          */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close Of Business Processing              */
/*                                                                   */
/*       CBC0056 - CONCATENATE PARAMETERS FOR REPORT AND COMPONENT   */
/*                 FOR CLOSE OF BUSINESS REPORTS                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 088495             Date 27Jun95              */
/*                      081912             Date 18Jan95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       088495 - Fix 081912 incomplete, if a non blank PARM         */
/*                received before the SEQ, no '' setup for non       */
/*                blank LVL.                                         */
/*       081912 - Allow string to be 256 for parameters              */
/*                                                                   */
/*********************************************************************/
/*/COPY WNCPYSRC,CBC0056001                                          */
             PGM        PARM(&TPARM &SEQ &LVL &ETY &PARM)
/*/COPY WNCPYSRC,CBC0056002                                          */
 
/************DCL        VAR(&TPARM) TYPE(*CHAR) LEN(100)               *081912*/
             DCL        VAR(&TPARM) TYPE(*CHAR) LEN(256)              /*081912*/
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ETY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(1) VALUE('''')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* IF &TPARM IS BLANK, SEQUENCE NUMBER SHOULD BE CONCATENATED WITH  */
/* IT WITH NO LEADING BLANKS. IF SEQUENCE NUMBER IS BLANK IT SHOULD */
/* BE REPLACED WITH A BLANK IN A SET OF SINGLE QUOTES. */
 
         IF         COND(&TPARM *EQ ' ') THEN(DO)
             IF         COND(&SEQ *EQ '     ') THEN(DO)
                        CHGVAR VAR(&TPARM) VALUE(&TPARM *TCAT ''' ''')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&TPARM) VALUE(&TPARM *TCAT &ASP *CAT &SEQ +
                          *CAT &ASP)
             ENDDO
         ENDDO
 
/* IF &TPARM IS NOT BLANK, SEQUENCE NUMBER SHOULD BE CONCATENATED   */
/* WITH IT WITH A LEADING BLANK.  */
 
         ELSE       CMD(DO)
             IF         COND(&SEQ *EQ '     ') THEN(DO)
                        CHGVAR VAR(&TPARM) VALUE(&TPARM *BCAT ''' ''')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&TPARM) VALUE(&TPARM *BCAT &ASP *CAT &SEQ +
                          *CAT &ASP)
             ENDDO
         ENDDO
 
/* IF LEVEL AND/OR ENTITY ARE BLANK THEY SHOULD */
/* BE REPLACED WITH A BLANK IN A SET OF SINGLE QUOTES. */
 
             IF         COND(&LVL *EQ ' ') THEN(DO)
                        CHGVAR VAR(&TPARM) VALUE(&TPARM *BCAT ''' ''')
             ENDDO
             ELSE       CMD(DO)
/**********             CHGVAR VAR(&TPARM) VALUE(&TPARM *BCAT &LVL)*/ /*088495*/
                        CHGVAR VAR(&TPARM) +
                         VALUE(&TPARM *BCAT &ASP *CAT &LVL *CAT &ASP) /*088495*/
             ENDDO
 
             IF         COND(&ETY *EQ '   ') THEN(DO)
                        CHGVAR VAR(&TPARM) VALUE(&TPARM *BCAT ''' ''')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&TPARM) VALUE(&TPARM *BCAT &ASP *CAT &ETY +
                          *CAT &ASP)
             ENDDO
 
 
/************CHGVAR     VAR(&TPARM) VALUE(&TPARM *BCAT &PARM)****/
/*/COPY WNCPYSRC,CBC0056003                                          */
             IF         COND(&PARM *NE ' ') THEN(CHGVAR VAR(&TPARM) +
                          VALUE(&TPARM *BCAT &ASP *CAT &PARM *BCAT +
                          &ASP))
/*/COPY WNCPYSRC,CBC0056004                                          */
 
 ENDPGM:     ENDPGM
