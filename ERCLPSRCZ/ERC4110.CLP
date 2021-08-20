/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS ER INTERFACE WITH PUMA-MINERV')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy                   */
/*                                                                   */
/*       ERC4110 - ER INTERFACE WITH PUMA-MINERVA                    */
/*                MINERVA Interface with system in HOUSE             */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1999          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 04Jan21              */
/*       Prev Amend No. MMI100             Date 05Nov02              */
/*                      MMI093             Date 04Mar02              */
/*                      MMI033                  06MAY99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MMI100 - Renamed from IRC4001 to ERC4110                    */
/*                                                                   */
/*       MMI093 - Rewritten                                          */
/*                                                                   */
/*       MMI033 - Bank Of Italy Monthly Reporting                    */
/*                MINERVA Interface with system in HOUSE             */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)

/* Get the library prefix */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&ERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')

             CLRPFM     FILE(&ERDLIB/IRMIHOPD)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(&ERDLIB/IRMIHOPD) RCDLEN(80) +
                          SIZE(*NOMAX))

/*********** CALL  PGM(IR4110) */                                     /*MMI100*/
             CALL  PGM(ER4110)                                        /*MMI100*/

/*********** CALL  PGM(IR4120) */                                     /*MMI100*/
             CALL  PGM(ER4120)                                        /*MMI100*/

             ENDPGM
