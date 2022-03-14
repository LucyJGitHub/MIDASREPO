/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - Create a Logical File in xxERDLIB')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting - ITALY                          */
/*                                                                   */
/*       ERLFDOWN - CREATE A LOGICAL FILE IN DOWLOAD LIBRARY         */
/*                                                                   */
/*       (c) Finastra Systems Technology, Inc. 2022                  */
/*                                                                   */
/*       Last Amend No. MD059459  *CREATE  Date 20Jan22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD059459 - Upgrade Italian Returns 142720 to FM 2021.B      */
/*       142720   Create logical files in download library.          */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&FILE &LIBCODE &RETCODE)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBCODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

/** Build library names  */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&ERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')
             CHGVAR     VAR(&DVLIB) VALUE(&PREFIX *CAT 'DVLIB')
             IF         COND(&LIBCODE = 'M') THEN(CHGVAR +
                          VAR(&LIBRARY) VALUE(&PREFIX *CAT +
                          'DMLIB'))
             IF         COND(&LIBCODE = 'P') THEN(CHGVAR +
                          VAR(&LIBRARY) VALUE(&PREFIX *CAT 'DPLIB'))

/** Delete any previous version of logical file in download library */

             DLTF       FILE(&ERDLIB/&FILE)
             MONMSG     MSGID(CPF0000)

/** Move logical to same library as physical, so that new logical */
/** will be based on physical in xxERDLIB                         */

             MOVOBJ     OBJ(&FILE) OBJTYPE(*FILE) TOLIB(&LIBRARY)
             CRTDUPOBJ  OBJ(&FILE) FROMLIB(&LIBRARY) OBJTYPE(*FILE) +
                          TOLIB(&ERDLIB)
             MOVOBJ     OBJ(&FILE) OBJTYPE(*FILE) TOLIB(&DVLIB)

             GOTO       CMDLBL(END)
ERROR:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&RETCODE) VALUE('*ERROR*')
END:
             ENDPGM
