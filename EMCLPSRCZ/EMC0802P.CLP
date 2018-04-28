/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM LIMITS REPORTING PROMPT')                    */
/********************************************************************/
/*                                                                  */
/*       Midas     EXPOSURE MANAGEMENT MODULE                   */
/*                                                                  */
/*       EMC0802P- CUSTOMER LIMIT/EXPOSURE/AVAILABILITY PROMPT      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No.  BUG18886        DATE  20May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No.  E38654          DATE  23APR92              */
/*                       LN0593          DATE  03AUG90              */
/*                                                                  */
/********************************************************************/
/*       BUG18886 - Non-standard codes exist in Midas Plus core     */
/*                  sources                                         */
/*       E38654 - PROMPT PGM SHOULD ALLOW FOR F12 AND F10           */
/*       LN0593 - REMOVING F12 FROM THE PROGRAMME AND CORRECT       */
/*                PROCESSING OF REQUEST                             */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*KEY')
             DCL        VAR(&SDCUST) TYPE(*CHAR) LEN(417)
             DCL        VAR(&KEYSTS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SDACOF) TYPE(*CHAR) LEN(39)
             DCL        VAR(&SDCTRY) TYPE(*CHAR) LEN(40)
             DCL        VAR(&SDREGC) TYPE(*CHAR) LEN(36)
             DCL        VAR(&SDINDC) TYPE(*CHAR) LEN(37)
             DCL        VAR(&TSTFLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CKEY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AKEY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TKEY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RKEY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&IKEY) TYPE(*CHAR) LEN(3)
/**/
             DCLF       FILE(EM0600FM)
/**/
/*  SET ALL ERROR INDICATORS OFF  */
/**/
             CHGVAR     VAR(&IN44) VALUE('0')
             CHGVAR     VAR(&IN75) VALUE('0')
             CHGVAR     VAR(&IN22) VALUE('0')
             CHGVAR     VAR(&IN23) VALUE('0')
             CHGVAR     VAR(&IN24) VALUE('0')
             CHGVAR     VAR(&IN25) VALUE('0')
             CHGVAR     VAR(&IN26) VALUE('0')
/**/
             RTVJOBA    JOB(&SWSID) USER(&USRID)
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)
/**/
/*  RECEIVE PARAMETERS IF AMEND, ENQUIRE OR DELETE  */
/**/
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)
             CHGVAR     VAR(&SRPTLV) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&SALL)   VALUE(%SST(&RPARM 2 3))
             CHGVAR     VAR(&SPNOSN) VALUE(%SST(&RPARM 5 10))
             CHGVAR     VAR(&SACOFF) VALUE(%SST(&RPARM 15 2))
             CHGVAR     VAR(&SCTRYC) VALUE(%SST(&RPARM 17 2))
             CHGVAR     VAR(&SREGCD) VALUE(%SST(&RPARM 19 2))
             CHGVAR     VAR(&SINDCD) VALUE(%SST(&RPARM 21 3))
 
             ENDDO
/**/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN05) +
                          VALUE('1'))
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN04) +
                          VALUE('1'))
/**/
 A:          SNDRCVF    RCDFMT(EM0600F1)
/**/
/*  RE-SET ERROR INDICATORS */
/**/
             CHGVAR     VAR(&IN40) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')
             CHGVAR     VAR(&IN22) VALUE('0')
             CHGVAR     VAR(&IN23) VALUE('0')
             CHGVAR     VAR(&IN24) VALUE('0')
             CHGVAR     VAR(&IN25) VALUE('0')
             CHGVAR     VAR(&IN26) VALUE('0')
             CHGVAR     VAR(&IN75) VALUE('0')
             CHGVAR     VAR(&ERRMSG) VALUE(*BLANKS)
/**/
/*  SET RETURN COMMANDS  */
/**/
             IF         COND(&IN07) THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('E')
             GOTO CMDLBL(END)
             ENDDO
/* IF F12, RETURN TO RCF WITH ACTION CODE = PREVIOUS  */              /*E38654*/
             IF         COND(&IN02 *EQ '1') THEN(DO)                  /*E38654*/
             CHGVAR     VAR(&RCMD) VALUE('F')                         /*E38654*/
             GOTO       CMDLBL(END)                                   /*E38654*/
             ENDDO                                                    /*E38654*/
/**/
/*           IF         COND(&IN02) THEN(DO)                            LN0593*/
/*           CHGVAR     VAR(&RCMD) VALUE('F')                           LN0593*/
/*           GOTO CMDLBL(END)                                           LN0593*/
/*           ENDDO                                                      LN0593*/
/**/
             IF         COND(&IN03) THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('D')
             GOTO CMDLBL(END)
             ENDDO
/**/
/*  CHECK VALIDATION ONLY WHEN INSERT OR AMEND */
/**/
             IF         COND(&RACT *EQ 'I' *OR &RACT *EQ 'A') THEN(DO)
/**/
             IF     COND(&SRPTLV *NE 'E' *AND &SRPTLV *NE 'F') THEN(DO)
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Only E or F is allowed')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             IF         COND(&SALL *NE '   ' *AND &SALL *NE 'ALL') +
                          THEN(DO)
             CHGVAR     VAR(&IN75) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Enter ALL or leave blank')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             IF         COND(&SALL *EQ '   ') THEN(GOTO CMDLBL(B))
/**/
             IF         COND(&SALL *EQ 'ALL' *AND &SPNOSN *NE +
                          '          ') THEN(DO)
             CHGVAR     VAR(&IN75) VALUE('1')
             CHGVAR     VAR(&IN22) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Cannot Specify ALL and +
                          an Option')
             GOTO       CMDLBL(A)
             ENDDO
/**/
 B:          IF         COND(&SPNOSN *EQ '          ') THEN(GOTO +
                          CMDLBL(C))
             CHGVAR     VAR(&TSTFLD) VALUE(%SST(&SPNOSN 7 4))
             IF         COND(&TSTFLD *EQ '    ') THEN(CHGVAR +
                          VAR(&KEYSTS) VALUE('*CNUM'))
             ELSE       CMD(CHGVAR VAR(&KEYSTS) VALUE('*CHST'))
/**/
             CHGVAR     VAR(&CKEY) VALUE(&SPNOSN)
/**/
             CALL       PGM(AOCUSTR0) PARM(&RTCD &OPTN &CKEY +
                          &KEYSTS &SDCUST)
             IF COND(&RTCD *NE '      ') THEN(DO)
             CHGVAR     VAR(&IN22) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Invalid Entry')
             GOTO       CMDLBL(A)
             ENDDO
             IF COND(&SPNOSN *EQ '?         ') THEN(DO)
             CHGVAR     VAR(&SPNOSN) VALUE(%SST(&SDCUST 1 6))
             GOTO       CMDLBL(A)
             ENDDO
/**/
 C:          IF         COND(&SACOFF *EQ '  ') THEN(GOTO CMDLBL(D))
/**/
             IF         COND(&SALL *EQ 'ALL' *AND &SACOFF *NE +
                          '  ') THEN(DO)
             CHGVAR     VAR(&IN75) VALUE('1')
             CHGVAR     VAR(&IN23) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Cannot Specify ALL and +
                          an Option')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             CHGVAR     VAR(&AKEY) VALUE(&SACOFF)
/**/
             CALL       PGM(AOACOFR0) PARM(&RTCD &OPTN &AKEY +
                           &SDACOF)
             IF COND(&RTCD *NE '      ') THEN(DO)
             CHGVAR     VAR(&IN23) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Invalid Entry')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             IF COND(&SACOFF *EQ '? ') THEN(DO)
             CHGVAR     VAR(&SACOFF) VALUE(%SST(&SDACOF 1 2))
             GOTO       CMDLBL(A)
             ENDDO
/**/
 D:          IF         COND(&SCTRYC *EQ '  ') THEN(GOTO CMDLBL(E))
/**/
             IF         COND(&SALL *EQ 'ALL' *AND &SCTRYC *NE +
                          '  ') THEN(DO)
             CHGVAR     VAR(&IN75) VALUE('1')
             CHGVAR     VAR(&IN24) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Cannot Specify ALL and +
                          an Option')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             CHGVAR     VAR(&TKEY) VALUE(&SCTRYC)
/**/
             CALL       PGM(AOCTRYR0) PARM(&RTCD &OPTN &TKEY +
                           &SDCTRY)
             IF COND(&RTCD *NE '      ') THEN(DO)
             CHGVAR     VAR(&IN24) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Invalid Entry')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             IF COND(&SCTRYC *EQ '? ') THEN(DO)
             CHGVAR     VAR(&SCTRYC) VALUE(%SST(&SDCTRY 1 2))
             GOTO       CMDLBL(A)
             ENDDO
/**/
 E:          IF         COND(&SREGCD *EQ '  ') THEN(GOTO CMDLBL(F))
/**/
             IF         COND(&SALL *EQ 'ALL' *AND &SREGCD *NE +
                          '  ') THEN(DO)
             CHGVAR     VAR(&IN75) VALUE('1')
             CHGVAR     VAR(&IN25) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Cannot Specify ALL and +
                          an Option')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             CHGVAR     VAR(&RKEY) VALUE(&SREGCD)
/**/
             CALL       PGM(AOREGNR0) PARM(&RTCD &OPTN &RKEY +
                           &SDREGC)
             IF COND(&RTCD *NE '      ') THEN(DO)
             CHGVAR     VAR(&IN25) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Invalid Entry')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             IF COND(&SREGCD *EQ '? ') THEN(DO)
             CHGVAR     VAR(&SREGCD) VALUE(%SST(&SDREGC 1 2))
             GOTO       CMDLBL(A)
             ENDDO
/**/
 F:          IF         COND(&SINDCD *EQ '  ') THEN(GOTO CMDLBL(SET))
/**/
             IF         COND(&SALL *EQ 'ALL' *AND &SINDCD *NE +
                          '  ') THEN(DO)
             CHGVAR     VAR(&IN75) VALUE('1')
             CHGVAR     VAR(&IN26) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Cannot Specify ALL and +
                          an Option')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             CHGVAR     VAR(&IKEY) VALUE(&SINDCD)
/**/
             CALL       PGM(AOINDSR0) PARM(&RTCD &OPTN &IKEY +
                           &SDINDC)
             IF COND(&RTCD *NE '      ') THEN(DO)
             CHGVAR     VAR(&IN26) VALUE('1')
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&ERRMSG) VALUE(' Invalid Entry')
             GOTO       CMDLBL(A)
             ENDDO
/**/
             IF COND(&SINDCD *EQ '?  ') THEN(DO)
             CHGVAR     VAR(&SINDCD) VALUE(%SST(&SDINDC 1 3))
             GOTO       CMDLBL(A)
             ENDDO
/**/
/* SET:        CHGVAR     VAR(&RPARM) VALUE(&SRPTLV ** &SALL ** &SPNOSN +
                          ** &SACOFF ** &SCTRYC ** &SREGCD ** &SINDCD) */ /* BUG18886 */
 SET:        CHGVAR     VAR(&RPARM) VALUE(&SRPTLV *CAT &SALL *CAT +
                          &SPNOSN *CAT &SACOFF *CAT &SCTRYC *CAT +
                          &SREGCD *CAT &SINDCD)                           /* BUG18886 */
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
