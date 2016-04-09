/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Update MODUPDATE data area in COB')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC9010 - Update MODUPDATE Data Area During COB.            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAAA01             DATE 30JUN95              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAAA01 - GUI/400 Development.                               */
/*                - Created for this development.                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SDC9010INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SDC9010MPS                                          */
 
/* Update SDMMIDPD so that it matches SDMMODPD */
 
             CALL       PGM(SD9010X) PARM(&RTNCODE)
 
             IF         COND(&RTNCODE *NE ' ') THEN(GOTO CMDLBL(ABNOR))
 
/* Ensure that the update SDMMIDPD flag is off */
 
             CALL       PGM(SDC9011) PARM('N')
 
/*/COPY WNCPYSRC,SDC9010MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SDC9010ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SDC9010END                                          */
 
             ENDPGM
