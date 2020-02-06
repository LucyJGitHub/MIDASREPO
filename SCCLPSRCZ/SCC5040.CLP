/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas clustering - initialise QCSTHAAPPI')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC5040 - Midas Clustering - Initialise QCSTHAAPPI          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 203050             Date 15Feb02              */
/*                      203043             Date 15Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSC013  *CREATE    Date 05Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       203050 - Several changes and enhancements                   */
/*       203043 - Move SCOBSPPD from xxDMLIB to xxDPLIB              */
/*       CSC013 - Midas Clustering Feature                           */
/*                - New program for this feature.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
/*/COPY WNCPYSRC,SCC5040INT                                          */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OSLVL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&APNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&APLVL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DESC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&APPCRG) TYPE(*CHAR) LEN(10)                                  /*203050*/
             DCL        VAR(&EXTPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRPRF) TYPE(*CHAR) LEN(10)                                  /*203050*/
             DCL        VAR(&EXTJOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RESTRT) TYPE(*CHAR) LEN(4)                                   /*203050*/
             DCL        VAR(&RETRYS) TYPE(*CHAR) LEN(4)                                   /*203050*/
             DCL        VAR(&LSTTYP) TYPE(*CHAR) LEN(4)                                   /*203050*/
             DCL        VAR(&NBRENT) TYPE(*CHAR) LEN(4)                                   /*203050*/
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NOSP1) TYPE(*CHAR) LEN(4)                                    /*203050*/
             DCL        VAR(&JRN1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JLB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CRG1) TYPE(*CHAR) LEN(10)                                    /*203050*/
             DCL        VAR(&LSTTYP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NBRENT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP3) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP4) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP5) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP6) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP7) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP8) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP9) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP10) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP11) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP12) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP13) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP14) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP15) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP16) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP17) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP18) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP19) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOSP20) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RCVVAR) TYPE(*CHAR) LEN(25)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('PRDR0100')
             DCL        VAR(&PRDINF) TYPE(*CHAR) LEN(27) +
                          VALUE('*OPSYS *CUR  0000*CODE    ')
             DCL        VAR(&MLICL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MLIRL) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSYSL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSIRL) TYPE(*CHAR) LEN(27)
             DCLF       FILE(QAFDMBR)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC5040MPS                                          */
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
 
/* Retrieve Midas system ID from data area SDSTAT */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
 
/* Determine operating system level */
 
             CALL       PGM(QSZRTVPR) PARM(&RCVVAR X'00000019' +
                          &FORMAT &PRDINF X'00000000')
 
/* Update operating system level of data area definition */
 
             CHGVAR     VAR(%SST(&OSLVL 1 6)) VALUE(%SST(&RCVVAR 20 6))
             CHGDTAARA  DTAARA(QCSTHAAPPI (1 10)) VALUE(&OSLVL)
 
/* Update application name - 'Midas' */
 
             CHGVAR     VAR(&APNAM) VALUE('Midas     ')
             CHGDTAARA  DTAARA(QCSTHAAPPI (11 10)) VALUE(&APNAM)
 
/* Update Midas Release */
 
/* Call to determine Release Licence level  */
 
             CALL       PGM(SCC0003) PARM(&MLICL '  ')
 
             CALL       PGM(SCC0002) PARM(&MLICL &MLIRL &MSYSL +
                          &MSIRL '  ')
 
             CHGVAR     VAR(&APLVL) VALUE(&MSYSL *CAT '.' *CAT +
                          %SST(&MSIRL 1 2))
             CHGDTAARA  DTAARA(QCSTHAAPPI (21 6)) VALUE(&APLVL)
 
/* Calculate description for this Midas system */
 
             CHGVAR     VAR(&DESC) VALUE('Midas' *BCAT &SYSID *BCAT +
                          'System')
             CHGDTAARA  DTAARA(QCSTHAAPPI (27 50)) VALUE(&DESC)
                                                                                          /*203050*/
/* Calculate recommended application CRG name */                                          /*203050*/
                                                                                          /*203050*/
             CHGVAR     VAR(&APPCRG) VALUE('MIDAS' *CAT &SYSID *CAT +
                          'APP')                                                          /*203050*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (111 10)) VALUE(&APPCRG)                        /*203050*/
 
/* Update Midas exit program name */
 
/*********   CHGVAR     VAR(&EXTPGM) VALUE('SC005000  ') */                               /*203050*/
             CHGVAR     VAR(&EXTPGM) VALUE('SCC5000   ')                                  /*203050*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (121 10)) VALUE(&EXTPGM)
 
/* Calculate Midas exit program name library name */
 
             RTVOBJD    OBJ(SC005000) OBJTYPE(*PGM) RTNLIB(&EXTLIB)
             CHGDTAARA  DTAARA(QCSTHAAPPI (131 10)) VALUE(&EXTLIB)
                                                                                          /*203050*/
/* Specify a default user profile name */                                                 /*203050*/
                                                                                          /*203050*/
             CHGVAR     VAR(&USRPRF) VALUE('MIDAS10   ')                                  /*203050*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (141 10)) VALUE(&USRPRF)                        /*203050*/
 
/* Calculate meaningful name for exit program job */
 
             CHGVAR     VAR(&EXTJOB) VALUE('MID' *CAT &SYSID *CAT +
                          'EXIT ')
             CHGDTAARA  DTAARA(QCSTHAAPPI (407 10)) VALUE(&EXTJOB)
                                                                                          /*203050*/
/* Update the restart indicator. */                                                       /*203050*/
                                                                                          /*203050*/
             CHGVAR     VAR(%BINARY(&RESTRT)) VALUE(0)                                    /*203050*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (417 4)) VALUE(&RESTRT)                         /*203050*/
                                                                                          /*203050*/
/* Update the number of restarts */                                                       /*203050*/
                                                                                          /*203050*/
             CHGVAR     VAR(%BINARY(&RETRYS)) VALUE(0)                                    /*203050*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (421 4)) VALUE(&RETRYS)                         /*203050*/
 
/* Update the list type - should be binary zero */
 
             CHGVAR     VAR(%BINARY(&LSTTYP)) VALUE(0)
             CHGDTAARA  DTAARA(QCSTHAAPPI (461 4)) VALUE(&LSTTYP)
 
/* Update the number of entries - should be binary 1 */
 
             CHGVAR     VAR(%BINARY(&NBRENT)) VALUE(1)
             CHGDTAARA  DTAARA(QCSTHAAPPI (465 4)) VALUE(&NBRENT)
 
/* Update the name of the object specifier file */
 
             CHGVAR     VAR(&FILE1) VALUE('SCOBSPPD  ')
             CHGDTAARA  DTAARA(QCSTHAAPPI (469 10)) VALUE(&FILE1)
 
/**Calculate*name*of*Midas*xxDTALIB**/                                                    /*203043*/
/* Calculate name of Midas xxDPLIB */                                                     /*203043*/
 
/**********  CHGVAR     VAR(&LIB1) VALUE(&SYSID *CAT 'DTALIB  ')                          /*203043*/
             CHGVAR     VAR(&LIB1) VALUE(&SYSID *CAT 'DPLIB   ')                          /*203043*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (479 10)) VALUE(&LIB1)
 
/* Update name of object specifier file member */
 
/*  '*FIRST' keyword is not valid.                                                        /*203050*/
/**********  CHGVAR     VAR(&MBR1) VALUE('*FIRST    ') */                                 /*203050*/
             CHGVAR     VAR(&MBR1) VALUE('SCOBSPPD  ')                                    /*203050*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (489 10)) VALUE(&MBR1)
 
/* Update the number of object specifiers. This is the number of */
/* records in the object specifier file, converted to binary.    */
 
             DSPFD      FILE(SCOBSPPD) TYPE(*MBR) OUTPUT(*OUTFILE) +
                          FILEATR(*PF) OUTFILE(QTEMP/SCOBSPRC) +
                          OUTMBR(SCOBSPRC)
 
             OVRDBF     FILE(QAFDMBR) TOFILE(QTEMP/SCOBSPRC) +
                          MBR(SCOBSPRC)
             RCVF
 
             CHGVAR     VAR(%BINARY(&NOSP1)) VALUE(&MBNRCD)
             CHGDTAARA  DTAARA(QCSTHAAPPI (499 4)) VALUE(&NOSP1)
 
/* Update name of journal - 'ICJRN' */
 
             CHGVAR     VAR(&JRN1) VALUE('ICJRN     ')
             CHGDTAARA  DTAARA(QCSTHAAPPI (503 10)) VALUE(&JRN1)
 
/* Calculate name of Midas xxJLIB */
 
             CHGVAR     VAR(&JLB1) VALUE(&SYSID *CAT 'JLIB    ')
             CHGDTAARA  DTAARA(QCSTHAAPPI (513 10)) VALUE(&JLB1)
                                                                                          /*203050*/
/* Calculate recommended data CRG name */                                                 /*203050*/
                                                                                          /*203050*/
             CHGVAR     VAR(&CRG1) VALUE('MIDAS' *CAT &SYSID *CAT +
                          'DTA')                                                          /*203050*/
             CHGDTAARA  DTAARA(QCSTHAAPPI (524 10)) VALUE(&CRG1)                          /*203050*/
 
/* Update the number of object specifiers for the remaining 19 */
/* possible entries                                            */
 
             CHGVAR     VAR(%BINARY(&NOSP2)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP3)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP4)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP5)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP6)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP7)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP8)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP9)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP10)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP11)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP12)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP13)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP14)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP15)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP16)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP17)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP18)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP19)) VALUE(0)
             CHGVAR     VAR(%BINARY(&NOSP20)) VALUE(0)
             CHGDTAARA  DTAARA(QCSTHAAPPI (575 4)) VALUE(&NOSP2)
             CHGDTAARA  DTAARA(QCSTHAAPPI (651 4)) VALUE(&NOSP3)
             CHGDTAARA  DTAARA(QCSTHAAPPI (727 4)) VALUE(&NOSP4)
             CHGDTAARA  DTAARA(QCSTHAAPPI (803 4)) VALUE(&NOSP5)
             CHGDTAARA  DTAARA(QCSTHAAPPI (879 4)) VALUE(&NOSP6)
             CHGDTAARA  DTAARA(QCSTHAAPPI (955 4)) VALUE(&NOSP7)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1031 4)) VALUE(&NOSP8)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1107 4)) VALUE(&NOSP9)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1183 4)) VALUE(&NOSP10)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1259 4)) VALUE(&NOSP11)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1335 4)) VALUE(&NOSP12)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1411 4)) VALUE(&NOSP13)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1487 4)) VALUE(&NOSP14)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1563 4)) VALUE(&NOSP15)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1639 4)) VALUE(&NOSP16)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1715 4)) VALUE(&NOSP17)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1791 4)) VALUE(&NOSP18)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1867 4)) VALUE(&NOSP19)
             CHGDTAARA  DTAARA(QCSTHAAPPI (1943 4)) VALUE(&NOSP20)
 
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,SCC5040MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC5040ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC5040 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCC5040END                                          */
 
             RCLRSC
 
             ENDPGM
