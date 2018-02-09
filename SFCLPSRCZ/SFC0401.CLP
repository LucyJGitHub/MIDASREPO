/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SF Set up SPF QTEMP dataareas')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SFC0401 - Set Up SPF Dataareas in QTEMP.                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1072179          Date 12Feb13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAP084             Date 08Jul03              */
/*                      CSF002             Date 11Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01463             Date 20JAN94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1072179 - APISERVFL and APISERVMQ jobs on MSGW            */
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       CSF002 - Global layer.                                      */
/*                - Replace previous key data with the new unique    */
/*                  code.                                            */
/*       S01463 - New program created to replace the SPF dataarea    */
/*                setup processing previously in MIPGM.              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ERRCOD) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
 
/* Global monitor */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Create the Midas Information Screen data area */                                    /*AR1072179*/
                                                                                       /*AR1072179*/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')                                    /*AR1072179*/
             MONMSG     MSGID(CPF1023)                                                 /*AR1072179*/
                                                                                       /*AR1072179*/
/* Create the data area ZMUSER in QTEMP */
 
             CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
 
/************   CALL       PGM(ZMUSER) PARM(&ERRCOD)                                      /*CAP084*/
                CALL       PGM(ZMUSER) PARM(&ERRCOD &ZMUSER)                              /*CAP084*/
 
                IF         COND(&ERRCOD *NE 0) THEN(DO)
 
/* Call SFC0700 to inform user that branch or dept is not valid */
 
                   RTVMSG     MSGID(SFM0007) MSGF(MIDASMSG) +
                                MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(SFM0008) MSGF(MIDASMSG) +
                                MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (401 50)) +
                                VALUE(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')
                   CALL       PGM(SFC0700) PARM('SFC0401' 'ENTER' ' ')
 
                   SIGNOFF    LOG(*LIST)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
 
/* Create the data area ZMITEM in QTEMP */
 
/**********  CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(9) + */                      /*CSF002*/
/**********               VALUE('D        ') TEXT('Midas SF +     */                      /*CSF002*/
/**********               Menu group/item code')                  */                      /*CSF002*/
             CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(10) +
                          TEXT('Midas SF Menu group/item code')                           /*CSF002*/
             MONMSG     MSGID(CPF1023)
 
/* Create the data area ZIG in QTEMP */
 
             CRTDTAARA  DTAARA(QTEMP/ZIG) TYPE(*CHAR) LEN(1) VALUE(' +
                          ') TEXT('Midas SF Show/remove +
                          menu group code')
             MONMSG     MSGID(CPF1023)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             SNDPGMMSG  MSG('SPF data initialisation terminated +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SFC0700 to inform the user that an error has occurred */
 
             RTVMSG     MSGID(SFM0020) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RTVMSG     MSGID(SFM0021) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CALL       PGM(SFC0700) PARM('SFC0401' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
