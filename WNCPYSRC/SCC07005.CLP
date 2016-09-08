/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC07 -  RE-OPENING OF INPUT CYCLE                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. LUC102  *CREATE    Date 17Dec14              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC102   - Re-Open Input Cycle Invocation of Bank's Program */
/*                                                                   */
/*********************************************************************/

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&SARD) VALUE('LUC102')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SFMT)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CALL       PGM(AOSVALR0) PARM(&RSVALRTNC 'LUC102_REOPEN_IC_PGM' +
                             &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                             &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                             &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)
                IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO CMDLBL(ABNOR))
                CHGVAR     VAR(&BNKPGM) VALUE(%SST(&SVAL1 1 10))
                CALL       &BNKPGM
             ENDDO

/*********************************************************************/
/*         End of /COPY SCC07005                                     */
/*********************************************************************/
