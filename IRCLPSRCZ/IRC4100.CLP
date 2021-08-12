/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Minerva Interface')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy                   */
/*                                                                   */
/*       IRC4100 - Minerva Interface - Create IRMITTPD/IRMITBPD      */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1999          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. MMI100             Date 16Jan03              */
/*                      MMI087             Date 03Jul01              */
/*                      MMI033  *CREATE         06MAY99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MMI100 - R4.1 upgrade                                       */
/*       MMI087 - DBA 3.02 upgrade - fill IRMITBPD                   */
/*       MMI033   MINERVA Interface                                  */
/*                                                                   */
/*********************************************************************/

             PGM
                                                                      /*MMI100*/
             DCL        VAR(&XXLIB) TYPE(*CHAR) LEN(2)                /*MMI100*/
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)              /*MMI100*/
                                                                      /*MMI100*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&XXLIB)           /*MMI100*/
             CHGVAR     VAR(&ERDLIB) VALUE(&XXLIB *CAT 'ERDLIB')      /*MMI100*/

             DSPFFD     FILE(IRPUMAPD) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/FFD)                          /*MMI087*/

             CPYF       FROMFILE(QTEMP/FFD) TOFILE(IRMITBPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*MMI087*/

             CPYF       FROMFILE(ARCTAB) TOFILE(IRM300PD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(DO)       /*MMI087*/

             SNDPGMMSG  MSG('Minerva file ARCTAB not found. Load +
                          file and retry.') TOPGMQ(*EXT)              /*MMI087*/
             GOTO       CMDLBL(END)                                   /*MMI087*/
             ENDDO                                                    /*MMI087*/

             CLRPFM     FILE(IRMITTPD)

             CALL       PGM(ER4100)

             RGZPFM     FILE(IRMITTPD) KEYFILE(*FILE)

             CPYF       FROMFILE(IRMITBPD) TOFILE(&ERDLIB/IRMITBPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*MMI100*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/IRMITBPD))                     /*MMI100*/

             CPYF       FROMFILE(IRMITTPD) TOFILE(&ERDLIB/IRMITTPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*MMI100*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/IRMITTPD))                     /*MMI100*/
END:
             ENDPGM
