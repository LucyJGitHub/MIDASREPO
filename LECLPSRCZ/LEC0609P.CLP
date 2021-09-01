/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Events file Creation for PUMA2')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0609R - Events file Creation for PUMA2                   */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139             Date 04Jan21              */
/*                      UIT021             Date 28feb97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     MD058100 - Rollup of additional BoI onsite fixes at FbMidas   */
/*     LUC139 - Upgrade UCI Italian Returns                          */
/*     UIT021 - BOI Monthly Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')

             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('UIT021')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&UIT021) TYPE(*CHAR) LEN(1) VALUE('N')

             DCLF       FILE(SDCLNDPD)

/***  Check if feature UIT021 is installed.  ***/

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPT &SAR)
             IF         COND(&RTCD *EQ '       ')  +
                   THEN(CHGVAR VAR(&UIT021) VALUE('Y'))

/***  If UIT021 not installed, then bypass.  ***/

             IF         COND(&UIT021 *NE 'Y') THEN(GOTO CMDLBL(ENDPGM))

             RCVF       RCDFMT(SDCLNDD0)

             SNDPGMMSG  MSG('Customer Lending Events file Creation +
                          for PUMA2') TOMSGQ(MRUNQ)

             CHGJOB     SWS(01XXXXXX)

/***  Use IML file as IML not installed in Italian system.   ***/

             CLRPFM     FILE(ERLVENHH)
             CLRPFM     FILE(ERLVENPD)
             CLRPFM     FILE(ERLVENZZ)

             IF         COND(&BPGEEB *NE 'Y') THEN(DO)

/***  Second Run for PUMA2 (Force BPGEEB to 'Y' in LE0480).  ***/

                 OVRDBF     FILE(TABLE) TOFILE(TABLEEI)
                 OVRDBF     FILE(TABLED) TOFILE(TABLEEI) SHARE(*NO)
                 OVRDBF     FILE(LVNTXHH) TOFILE(ERLVENHH)
                 OVRDBF     FILE(LVNTXEL) TOFILE(ERLVENPD)
                 OVRDBF     FILE(LVNTXZZ) TOFILE(ERLVENZZ)

                 CALL       PGM(LE0480)

                 DLTOVR     FILE(*ALL)

             ENDDO

             IF         COND(&BPGEEB *EQ 'Y') THEN(DO)

/***  Make a copy onto New events file.   ***/

             CPYF       FROMFILE(LVENTEL) TOFILE(ERLVENPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLVENPD))

             ENDDO

             CHGJOB     SWS(00XXXXXX)

ENDPGM:
             CHGVAR     VAR(&CPYFLD) +
                     VALUE('Copyright Midas-Kapiti International Ltd.')

             ENDPGM
