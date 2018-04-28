/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Rename Main database back')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC1606 - Rename Main database back                         */
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
             DCL        VAR(&MSDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSDPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSDVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSDTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSDTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Build the Main and Support database names. */
             CHGVAR     VAR(&MSDMLIB) VALUE(&MSPREFIX *CAT 'DMLIB')
             CHGVAR     VAR(&MSDPLIB) VALUE(&MSPREFIX *CAT 'DPLIB')
             CHGVAR     VAR(&MSDVLIB) VALUE(&MSPREFIX *CAT 'DVLIB')
             CHGVAR     VAR(&MSDTLIB) VALUE(&MSPREFIX *CAT 'DTALIB')
 
             CHGVAR     VAR(&SSDMLIB) VALUE(&SSPREFIX *CAT 'DMLIB')
             CHGVAR     VAR(&SSDPLIB) VALUE(&SSPREFIX *CAT 'DPLIB')
             CHGVAR     VAR(&SSDVLIB) VALUE(&SSPREFIX *CAT 'DVLIB')
             CHGVAR     VAR(&SSDTLIB) VALUE(&SSPREFIX *CAT 'DTALIB')
 
RENAME_DM:
             RNMOBJ     OBJ(&SSDMLIB) OBJTYPE(*LIB) NEWOBJ(&MSDMLIB)
/* If the Main System DMLIB already exists then this assumes the */
/*  rename has already been run. */
             MONMSG     MSGID(CPF2111) EXEC(DO)
                GOTO       CMDLBL(RENAME_DP)
             ENDDO
RENAME_DP:
             RNMOBJ     OBJ(&SSDPLIB) OBJTYPE(*LIB) NEWOBJ(&MSDPLIB)
/* If the Main System DPLIB already exists then this assumes the */
/*  rename has already been run. */
             MONMSG     MSGID(CPF2111) EXEC(DO)
                GOTO       CMDLBL(RENAME_DT)
             ENDDO
RENAME_DT:
             RNMOBJ     OBJ(&SSDTLIB) OBJTYPE(*LIB) NEWOBJ(&MSDTLIB)
/* If the Main System DTALIB already exists then this assumes the */
/*  rename has already been run. */
             MONMSG     MSGID(CPF2111) EXEC(DO)
                GOTO       CMDLBL(RENAME_DV)
             ENDDO
RENAME_DV:
             RNMOBJ     OBJ(&SSDVLIB) OBJTYPE(*LIB) NEWOBJ(&MSDVLIB)
/* If the Support System DVLIB already exists then this assumes the */
/*  rename has already been run. */
             MONMSG     MSGID(CPF2111) EXEC(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
