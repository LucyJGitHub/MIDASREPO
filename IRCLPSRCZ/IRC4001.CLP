/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR ER INTERFACE WITH PUMA-MINERVA')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy                   */
/*                                                                   */
/*       IRC4001 - ER INTERFACE WITH PUMA-MINERVA                    */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1999          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. MMI033             Date 06MAY99              */
/*                      xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MMI033 - Bank Of Italy Monthly Reporting                    */
/*                MINERVA Interface with system in HOUSE             */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&@XXLIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&@ERDLIB) TYPE(*CHAR) LEN(10)

/* Get the library prefix */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&@XXLIB)
             CHGVAR     VAR(&@ERDLIB) VALUE(&@XXLIB *CAT 'ERDLIB')

             CLRPFM     FILE(&@ERDLIB/IRMIHOPD)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(&@ERDLIB/IRMIHOPD) RCDLEN(80) +
                          SIZE(500000 10000))

             OVRDBF     FILE(M1LIR) TOFILE(&@ERDLIB/IRMIHOPD)

             CALL  PGM(IR4500)

             CALL  PGM(IR4510)

             DLTOVR     FILE(M1LIR)

             ENDPGM
