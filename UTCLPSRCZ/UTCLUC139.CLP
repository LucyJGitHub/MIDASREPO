/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('LUC139 file set up utility')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas SD - Standing Data Module                             */
/*                                                                   */
/*       UTCLUC139 - Midas UT Italian returns utility                */
/*                                                                   */
/*       (c) Finastra International Systems Ltd. 2021                */
/*                                                                   */
/*       Last Amend No. LUC139   *Create   Date 20Jan21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - UCI Italian returns Upgrade to FM2.1               */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) Finastra +
                          International Systems Ltd. 2021')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)

             CHGJOB     SWS(00000000)

             SNDMSG     MSG('LUC139 File set up utility') TOMSGQ(MRUNQ)
             CPYF       FROMFILE(SDBOOKXP) TOFILE(SDBKT1PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(SDBRCHXP) TOFILE(SDBRT1PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(SDCTRYXP) TOFILE(SDCTT1PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(SDCURRXP) TOFILE(SDCRT1PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(SDCUSTXI) TOFILE(SDCUT1PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(SDCUSTXP) TOFILE(SDCUT2PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(FXDEALXP) TOFILE(DLFXT1PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(MMDELDXP) TOFILE(DLLDT1PD) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CLRPFM     FILE(LECLT1PD)
             CLRPFM     FILE(LEFCT1PD)
             CLRPFM     FILE(LEGTT1PD)
             CLRPFM     FILE(SDACT1PD)
             CLRPFM     FILE(REACT1PD)

             CALL       PGM(UTLUC139)

             RTVJOBA    SWS(&SWS)
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO

             ENDPGM
