/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas TM Control FX take on')                         */
/********************************************************************/
/*                                                                  */
/*       Midas     - Treasury Management Module                     */
/*                                                                  */
/*       TMC0110 - Control Take-on of FX Trades                     */
/*                                                                  */
/*       Function:  Controls take-on of FX trades.  It will run     */
/*                  when the Treasury Management module is switched */
/*                  on in an existing system.                       */
/*                  This program is based on FD0720.                */
/*                                                                  */
/*       Called by: TMC0100 - TM Take-on menu.                      */
/*                                                                  */
/*       Calls:     FX0680 - Setup daily equivalent - postion &     */
/*                           profits.                               */
/*                  TM0120 - Control update of TM database by FX    */
/*                           deals.                                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. XXXXXX             Date 00XXX00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       XXXXXX -                                                    */
/*                                                                   */
/********************************************************************/
             PGM
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(FXDEALLL)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/** Set job switches off for error control.                          */
             CHGJOB     SWS(00000000)
 
/** Clear files.                                                     */
             CLRPFM     FILE(FXEPOSPP)
             CLRPFM     FILE(FXFWDDPP)
             CLRPFM     FILE(FXFWDHPP)
 
/** Overide deals file and open for input.                           */
             OVRDBF     FILE(FXDEALLL) SHARE(*NO)
             OPNDBF     FILE(FXDEALLL) OPTION(*INP)
 
/** Read the file, monitoring for EoF.                               */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
 
/** If no records on file, call FX0680 to update positions file with */
/** online and nostro positions; then end processing.                */
                CALL       PGM(FX0680)
 
/** If an error has occurred in the called program, end this program */
/** in error.                                                        */
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ERROR))
 
/** Close the file.                                                  */
                CLOF       OPNID(FXDEALLL)
 
/** End program.                                                     */
                GOTO       CMDLBL(END)
 
             ENDDO
 
/** Close the file.                                                  */
             CLOF       OPNID(FXDEALLL)
 
/** If an error has occurred in the called program, end this program */
/** in error.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
 
/** Call TM0120 to update the TM database                            */
             CALL       PGM(TM0120) PARM(&ERROR)
 
/** End program if there has been a program or database              */
/** error.                                                           */
             IF         COND(&ERROR *EQ 'Y' *OR %SWITCH(XXXXXX11)) +
                          THEN(DO)
                          ROLLBACK
                          GOTO CMDLBL(ERROR)
                          ENDDO
 
/** If no errors then commit changes.                                */
             COMMIT
 
/** Close all files.                                                 */
             RCLRSC
 
/** Call FX0680 to update positions file with online and nostro      */
/** positions.                                                       */
             CALL       PGM(FX0680)
 
/** If an error has occurred in the called program, end this program */
/** in error.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
 
 
/** End program.                                                     */
             GOTO       CMDLBL(END)
 
ERROR:
 
/** Error handling routine; monitor on each line to prevent looping  */
/** if there is another error.                                       */
             CHGJOB     SWS(XXXXX1XX)
             MONMSG     MSGID(CPF0000)
 
/** Set up the LDA fields.                                           */
             CHGDTAARA  DTAARA(*LDA (171 10)) VALUE('TMC0110   ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('001')
             MONMSG     MSGID(CPF0000)
 
/** Notify the user of the error.                                    */
             SNDPGMMSG  MSG('Error in FX deals takeon; see dump and +
                          joblog.') TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000)
 
/** Dump the program.                                                */
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
END:
             RCLRSC
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
