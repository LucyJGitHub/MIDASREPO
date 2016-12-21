/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB build environment')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0510 - COB Build Environment                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD043121           Date 21Dec16              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB014             Date 25Apr05              */
/*                      CCB012             Date 20May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 09Nov01              */
/*                      196795             Date 13Aug01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK008             Date 01JUL97              */
/*                      S01408             Date 07AUG95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD043121 - Scheduled COB unable to proceed due to LCKW      */
/*                  in job SDC_COB                                   */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*       CCB012 - Use 70 job streams.  Change to data areas CBRECV,  */
/*                CBTRAN and CBCTRL.                                 */
/*       CPK014 - Release 4 packaging:                               */
/*                - DTAARA/CBCTRL is now a delivered object and      */
/*                  resides in the DPLIB.                            */
/*                - DTAARA/CBLMSG is now a delivered object and      */
/*                  resides in the DPLIB.                            */
/*                - DTAARA/CBLOCK is now a delivered object and      */
/*                  resides in the DPLIB.                            */
/*       196795 - Use DTAARA CBRECV instead of DTAQ MAINDTQ to avoid */
/*                object lock at V5R1M0.                             */
/*       CPK008 - DBA R2 Packaging                                   */
/*              - Size of components run/to run counters changed.    */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0510INT                                       */
/*                - CBC0510MPS                                       */
/*                - CBC0510MPE                                       */
/*                - CBC0510ERR                                       */
/*                - CBC0510END                                       */
/*       S01420 - CoB Enhancements                                   */
/*                                                                   */
/*********************************************************************/
             PGM

/*/COPY WNCPYSRC,CBC0510INT                                          */
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CCB014*/
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)                                 /*CCB014*/
             DCL        VAR(&AUTSCH) TYPE(*CHAR) LEN(1)                                   /*CCB014*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CCB014*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CCB014*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CCB014*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CCB014*/

             DCL        VAR(&PRELIB) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10) VALUE('  + */                   /*CPK014*/
/**********               XLIB    ')                                 */                   /*CPK014*/
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10) VALUE('  +
                          DPLIB   ')                                                      /*CPK014*/
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')

/* Global error message trap */

             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/*/COPY WNCPYSRC,CBC0510MPS                                          */
                                                                                          /*CCB014*/
/* Check to see if Automatic Scheduling is On */                                          /*CCB014*/
                                                                                          /*CCB014*/
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&AUTSCH)                              /*CCB014*/
                                                                                          /*CCB014*/
/* Check to see if the Delay COB Feature is set On (CCB014) */                            /*CCB014*/
                                                                                          /*CCB014*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CCB014*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CCB014*/
             CHGVAR     VAR(&SAR) VALUE('CCB014')                                         /*CCB014*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                          &SCSARD)                                                        /*CCB014*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))                                        /*CCB014*/

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)

             CHGVAR     VAR(%SST(&DTAQLIB 1 2)) VALUE(&PRELIB)

             RTVMSG     MSGID(SCM0101) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0102) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
/*/COPY WNCPYSRC,CBC0510001                                          */
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(GOTO CMDLBL(TAGUSC1))                                      /*CCB014*/
             CALL       PGM(SCC0010) PARM('CBC0510' '     ' &NOREPLY)
/*/COPY WNCPYSRC,CBC0510002                                          */
TAGUSC1:                                                                                  /*CCB014*/

/* Remove any old data queues */

             DLTDTAQ    DTAQ(DTQ*)
             MONMSG     MSGID(CPF0000)

             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(DO)                                                      /*MD043121*/
             RUNSQL SQL('delete from CBUSERPD') COMMIT(*NONE)                           /*MD043121*/
             RUNSQL SQL('delete from CBDSCJPD') COMMIT(*NONE)                           /*MD043121*/
             RUNSQL SQL('delete from CBTRACPD') COMMIT(*NONE)                           /*MD043121*/
             ENDDO                                                                      /*MD043121*/
             ELSE       CMD(DO)                                                         /*MD043121*/
/* Clear user physical file */

             CLRPFM     FILE(CBUSERPD)
             MONMSG     MSGID(CPF0000)

/* Clear work file */

             CLRPFM     FILE(CBDSCJPD)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(CBTRACPD)
             MONMSG     MSGID(CPF0000)
             ENDDO                                                                      /*MD043121*/

/* Create user space */

             DLTUSRSPC  USRSPC(*LIBL/USRTRACE)
             MONMSG     MSGID(CPF0000)
             DLTUSRSPC  USRSPC(*LIBL/USERLOCK)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT &DTAQLIB)

             CALL       PGM(QUSCRTUS) PARM(&QUAL '          ' +
                          X'00000300' ' ' '*ALL      ' 'Temporary +
                          user space ')
             CHGVAR     VAR(&QUAL) VALUE('USERLOCK  ' *CAT &DTAQLIB)

             CALL       PGM(QUSCRTUS) PARM(&QUAL '          ' +
                          X'00000030' ' ' '*ALL      ' 'Temporary +
                          user space ')

/* Create data queue used by batch monitor */

/**********  DLTDTAQ    DTAQ(&DTAQLIB/MONBCHQ)             */                             /*CPK014*/
/**********  MONMSG     MSGID(CPF0000)                     */                             /*CPK014*/
/**********                                                */                             /*CPK014*/
/**********  CRTDTAQ    DTAQ(&DTAQLIB/MONBCHQ) MAXLEN(1)   */                             /*CPK014*/

/**********  DLTDTAARA  DTAARA(&DTAQLIB/CBLOCK)            */                             /*CPK014*/
/**********  MONMSG     MSGID(CPF0000)                     */                             /*CPK014*/
/**********                                                */                             /*CPK014*/
/**Create*data*area*used*when*monitor*locked****************/                             /*CPK014*/
/**********                                                */                             /*CPK014*/
/**********  DLTDTAARA  DTAARA(&DTAQLIB/CBLOCK)            */                             /*CPK014*/
/**********  MONMSG     MSGID(CPF0000)                     */                             /*CPK014*/
/**********  CRTDTAARA  DTAARA(&DTAQLIB/CBLOCK) TYPE(*CHAR)*+                             /*CPK014*/
/**********               LEN(10)                          */                             /*CPK014*/

/* Create data area in charge to contain the last message sent */

/**********  DLTDTAARA  DTAARA(&DTAQLIB/CBLMSG) */                                        /*CPK014*/
/**********  MONMSG     MSGID(CPF0000)          */                                        /*CPK014*/
/**********  CRTDTAARA  DTAARA(&DTAQLIB/CBLMSG) TYPE(*CHAR) +                             /*CPK014*/
/**********               LEN(42)               */                                        /*CPK014*/
             CHGDTAARA  DTAARA(CBLMSG (41 2)) VALUE('01')

/**********  DLTDTAARA  DTAARA(&DTAQLIB/CBCTRL) */                                        /*CPK014*/
/**********  MONMSG     MSGID(CPF0000)          */                                        /*CPK014*/
/**********  CRTDTAARA  DTAARA(&DTAQLIB/CBCTRL) TYPE(*CHAR) +                             /*CPK014*/
/**********               LEN(512)              */                                        /*CPK014*/

/* Create data area in charge of transmit data from monitor */

/************DLTDTAARA  DTAARA(&DTAQLIB/CBTRAN)                                           /*196795*/
/************MONMSG     MSGID(CPF0000)                                                    /*196795*/
/************CRTDTAARA  DTAARA(&DTAQLIB/CBTRAN) TYPE(*CHAR) +                             /*196795*/
/************             LEN(1024)                                                       /*196795*/

/* Initialise data area */

             CHGDTAARA  DTAARA(CBTRAN *ALL) VALUE(' ')                                    /*196795*/
/************CHGDTAARA DTAARA(CBTRAN (97 12)) VALUE('000000000000')   /*CPK008*/
             CHGDTAARA  DTAARA(CBTRAN (97 2)) VALUE('00')             /*CPK008*/
             CHGDTAARA  DTAARA(CBTRAN (105 4)) VALUE('0000')          /*CPK008*/
/**********  CHGDTAARA  DTAARA(CBTRAN (849 8)) VALUE('00000000')               /*CPK008*/ /*CCB012*/
/**********  CHGDTAARA  DTAARA(CBTRAN (1022 3)) VALUE('000') */                           /*CCB012*/
             CHGDTAARA  DTAARA(CBTRAN (1089 8)) VALUE('00000000')                         /*CCB012*/
             CHGDTAARA  DTAARA(CBTRAN (1097 3)) VALUE('000')                              /*CCB012*/

/* Create data area in charge of receive data from monitor */

/************DLTDTAARA  DTAARA(&DTAQLIB/CBRECV)                                           /*196795*/
/************MONMSG     MSGID(CPF0000)                                                    /*196795*/

/************CRTDTAARA  DTAARA(&DTAQLIB/CBRECV) TYPE(*CHAR) +                             /*196795*/
/************             LEN(1024)                                                       /*196795*/

/* Initialise data area */

/************CHGDTAARA DTAARA(CBRECV (97 12)) VALUE('000000000000')/   *CPK008*/
             CHGDTAARA  DTAARA(CBRECV (97 2)) VALUE('00')             /*CPK008*/
             CHGDTAARA  DTAARA(CBRECV (105 4)) VALUE('0000')          /*CPK008*/
/**********  CHGDTAARA  DTAARA(CBRECV (849 8)) VALUE('00000000') */            /*CPK008*/ /*CCB012*/
/**********  CHGDTAARA  DTAARA(CBRECV (1097 3)) VALUE('000') */                           /*CCB012*/
             CHGDTAARA  DTAARA(CBRECV (1089 8)) VALUE('00000000')                         /*CCB012*/
             CHGDTAARA  DTAARA(CBRECV (1022 3)) VALUE('000')                              /*CCB012*/

/************DLTDTAQ    DTAQ(*LIBL/MAINDTQ)                                               /*196795*/
/************MONMSG     MSGID(CPF0000)                                                    /*196795*/
/************CRTDTAQ    DTAQ(&DTAQLIB/MAINDTQ) MAXLEN(1024) +                             /*196795*/
/************             SEQ(*KEYED) KEYLEN(10) TEXT('Main data +                        /*196795*/
/************             queue')                                                         /*196795*/

/*/COPY WNCPYSRC,CBC0510MPE                                          */

             GOTO       CMDLBL(ENDP)

ABNOR:
/*/COPY WNCPYSRC,CBC0510ERR                                          */

              CHGJOB     SWS(XXXXXX11)

ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')

/*/COPY WNCPYSRC,CBC0510END                                          */

 ENDPGM:     ENDPGM
