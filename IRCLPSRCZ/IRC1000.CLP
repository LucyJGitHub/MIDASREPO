/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Main Component for Minerva Interface')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy.                  */
/*                                                                   */
/*       IRC1000  - Main Component for Minerva Interface             */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1998          */
/*                                                                   */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139   *Amend    Date 02Mar21              */
/*                      LUC139             Date 21Dec20              */
/*                      MMI033   *CREATE   Date 08Oct98              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD058100 - Rollup of additional BoI onsite fixes at FbMidas */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*              - Use SDCUT2PD instead of SDCUSTXP                   */
/*       MMI033 - Midas Italy Puma/2 Extract Change 3                */
/*                                                                   */
/*********************************************************************/
             PGM

/*   Variables declaration                                           */

             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)

/*   Global error trap                                               */

             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ABNOR))

/*   Extract customer details to M1LIR                                */

             CLRPFM     FILE(IRCUSTPD)

             OVRDBF     FILE(IR1100PD) TOFILE(SDCUT2PD) SHARE(*YES)
             OPNQRYF    FILE((SDCUT2PD) (SDCUSTPD)) FORMAT(IR1100PD) +
                          JFLD((1/PCCUST 2/BBCUST)) JORDER(*FILE) +
                          IGNDECERR(*YES)

             CALL       PGM(IR1100)

             CLOF       OPNID(SDCUT2PD)
             DLTOVR     FILE(IR1100PD)


             IF         COND(%SWITCH(XXXXXXX1) *OR +
                          %SWITCH(XXXXXX1X)) THEN(GOTO CMDLBL(DBERR))


/*   Transfer records from ERITTRPD to IRPUMAPD                       */

             CLRPFM     FILE(IRPUMAPD)

             CALL       PGM(IR1000)

             IF         COND(%SWITCH(XXXXXXX1) *OR +
                          %SWITCH(XXXXXX1X)) THEN(GOTO CMDLBL(DBERR))

             CALL       PGM(IRC4000)
             IF         COND(%SWITCH(XXXXXXX1) *OR +
                          %SWITCH(XXXXXX1X)) THEN(GOTO CMDLBL(DBERR))

             GOTO       CMDLBL(ENDPGM)

/*   Data base error                                      */

DBERR:       RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)

/*   Unsuccesful completion -                             */

ABNOR:       CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('ERCITMIN - MINERVA INTERFACE FAILED') +
                          TOMSGQ(ERMSGQ) MSGTYPE(*INFO)

 ENDPGM:     ENDPGM
