/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Restore Support System database')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC1608 - Restore Support System database                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP016  *CREATE    Date 02Dec02              */
/*       Prev Amend No. Xxxxxx             Date nnXXXnn              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSPREFIX &SSPREFIX)
 
             DCL        VAR(&MSPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SSPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSDZLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TIDTA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Build Support database names. */
             CHGVAR     VAR(&SSDMLIB) VALUE(&SSPREFIX *CAT 'DMLIB')
             CHGVAR     VAR(&SSDPLIB) VALUE(&SSPREFIX *CAT 'DPLIB')
             CHGVAR     VAR(&SSDVLIB) VALUE(&SSPREFIX *CAT 'DVLIB')
             CHGVAR     VAR(&SSDTLIB) VALUE(&SSPREFIX *CAT 'DTALIB')
 
             CHGVAR     VAR(&MSDZLIB) VALUE(&MSPREFIX *CAT 'DZLIB')
 
DMLIB:
/* If Suppport System library already exists then assume it has already run. */
             CHKOBJ     OBJ(&SSDMLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                RSTLIB     SAVLIB(&SSDMLIB) DEV(*SAVF) +
                             SAVF(&MSDZLIB/&SSDMLIB) OUTPUT(*PRINT)
             ENDDO
 
DPLIB:
/* If Suppport System library already exists then assume it has already run. */
             CHKOBJ     OBJ(&SSDPLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                RSTLIB     SAVLIB(&SSDPLIB) DEV(*SAVF) +
                             SAVF(&MSDZLIB/&SSDPLIB) OUTPUT(*PRINT)
             ENDDO
 
DTLIB:
/* If Suppport System library already exists then assume it has already run. */
             CHKOBJ     OBJ(&SSDTLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                RSTLIB     SAVLIB(&SSDTLIB) DEV(*SAVF) +
                             SAVF(&MSDZLIB/&SSDTLIB) OUTPUT(*PRINT)
             ENDDO
 
DVLIB:
/* If Suppport System library already exists then assume it has already run. */
             CHKOBJ     OBJ(&SSDVLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                RSTLIB     SAVLIB(&SSDVLIB) DEV(*SAVF) +
                             SAVF(&MSDZLIB/&SSDVLIB) OUTPUT(*PRINT)
             ENDDO
 
/* Change system IDs on the Support System. */
SDSTAT:
             CHGDTAARA  DTAARA(&SSDMLIB/SDSTAT (6 2)) VALUE(&SSPREFIX)
CGDTA:
             CHGDTAARA  DTAARA(&SSDMLIB/CGDTA (7 2)) VALUE(&SSPREFIX)
TIDTA:
             RTVDTAARA  DTAARA(&SSDMLIB/TIDTA) RTNVAR(&TIDTA)
             IF         COND(%SST(&TIDTA 11 2) *NE ' ') THEN(DO)
                CHGDTAARA  DTAARA(&SSDMLIB/TIDTA (11 2)) VALUE(&SSPREFIX)
             ENDDO
 
/* Delete save files. */
             DLTF       FILE(&MSDZLIB/&SSDMLIB)
             DLTF       FILE(&MSDZLIB/&SSDPLIB)
             DLTF       FILE(&MSDZLIB/&SSDTLIB)
             DLTF       FILE(&MSDZLIB/&SSDVLIB)
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
