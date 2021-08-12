/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy.                  */
/*                                                                   */
/*       IRC01   - Next day Setup                                    */
/*                 Called in EOM only                                */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT024             Date 01Jun98              */
/*                      UIT021             Date 31jan97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT024 - National Bank of Italy Anti-Laundering Reporting   */
/*       UIT021 - BOI Monthly Reporting                              */
/*                                                                   */
/*********************************************************************/
             PGM

/***  Declare variable.  ***/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('UIT021')
             DCL        VAR(&IRSTAT) TYPE(*CHAR) LEN(50) VALUE('   ')

/***  Monitor for Error Messages from System.  ***/
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ERROR))

/***  Check either UIT021 is installed, else leave.  ***/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD)
             IF         COND(&RTN *NE '       ') THEN(GOTO CMDLBL(END))

/***  Execute this processing if the PUMA2 Feature is installed.  ***/
             SNDPGMMSG  MSG('BOI Monthly Reporting - Next Day Set Up') +
                          TOMSGQ(MRUNQ)

/***  If end of month, copy monthly file to previous month's file      ***/
             CPYF       FROMFILE(IRMPSTPD) TOFILE(IRPMPCPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(IRPMPCPD))

/***  Clear Current monthly reporting file.  ***/
             CLRPFM     FILE(IRMPSTPD)

/***  Clear Monthly movements extracted and passed     ***/
/***  to xxERDLIB for reporting purposes (see ERC0700) ***/
             CLRPFM     FILE(ERITDTPD)

/***  Reset Relative record number of IRSTAT data area.   ***/
             CHGDTAARA  DTAARA(IRSTAT (10 6)) VALUE('000000')

             CALL       PGM(IR0005)

/***  Check either UIT024 is installed, else leave.  ***/             /*UIT024*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN 'UIT024')        /*UIT024*/
             IF         COND(&RTN *NE '       ') +
                                      THEN(GOTO CMDLBL(END))          /*UIT024*/

/***  Execute this processing if Anti-Laundering is installed.  ***/  /*UIT024*/
             SNDPGMMSG  MSG('Anti-Laundering Monthly Reporting - +
                          Next Day Set Up') TOMSGQ(MRUNQ)             /*UIT024*/

/***  If end of month, copy monthly file to previous month's file **/ /*UIT024*/
             CPYF       FROMFILE(IRMAMPPD) TOFILE(IRMAPPPD) +
                          MBROPT(*REPLACE)                            /*UIT024*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(IRMAPPPD))                             /*UIT024*/

/***  Clear Current monthly reporting file.  ***/                     /*UIT024*/
             CLRPFM     FILE(IRMAMPPD)                                /*UIT024*/

/***  Clear Monthly movements extracted and passed     ***/           /*UIT024*/
/***  to xxERDLIB for reporting purposes (see ERC0700) ***/           /*UIT024*/
             CLRPFM     FILE(IRMAOPPD)                                /*UIT024*/
             CLRPFM     FILE(IRMAPAPD)                                /*UIT024*/

/***  Reset Relative record number of IRMAST data area.   ***/        /*UIT024*/
             CHGDTAARA  DTAARA(IRMAST (10 6)) VALUE('000000')         /*UIT024*/
             GOTO       CMDLBL(END)

/***  Send Message.  ***/
 ERROR:      SNDPGMMSG  MSG('BOI Monthly reporting Copy - Next Day +
                          Set Up ended abnormally.') TOMSGQ(MRUNQ +
                          MOPERQ)

 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('Copyright Midas-Kapiti International Ltd.')
             ENDPGM
