/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP Copy Spool Items')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPCCPYSPI - Copy Spool Items                                */
/*                                                                   */
/*       (c) Finastra Systems Technology, Inc. 2019                  */
/*                                                                   */
/*       Last Amend No. DAI103A            Date 10Jul19              */
/*       Prev Amend No. DAI103             Date 25Jun19              */
/*                      FRAIMP             Date 16Apr13              */
/*                      NADC02             Date 12Jun12              */
/*                      NADC01  *CREATE    Date 17Nov09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DAI103A - Changed reference to file attributes              */
/*       DAI103 - Upgraded MPlus 121 NADC01, NADC02, FRAIMP ML       */
/*                Extracts to FB 2.1                                 */
/*       FRAIMP - ML Reporting to include FRA                        */
/*       NADC02 - ML REPORTING TO INCLUDE IRS                        */
/*       NADC01 - ML EXTRACTS FOR MIZUHO                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SPLF &EXC &BJMRDT)
             DCL        VAR(&SPLF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXC )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&BJMRDT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DIR)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOOB)   TYPE(*CHAR) LEN(90)
/**********  DCLF       FILE(QTEMP/FD)                                */                 /*DAI103A*/
             DCLF       FILE(QAFDBASI) OPNID(FILEINFO)                                   /*DAI103A*/
 
             DLTF       FILE(QTEMP/NAD)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(QTEMP/FD)                                                   /*DAI103A*/
             MONMSG     MSGID(CPF0000)                                                   /*DAI103A*/
                                                                                         /*DAI103A*/
             DSPFD      FILE(&SPLF) TYPE(*BASATR) OUTPUT(*OUTFILE) OUTFILE(QTEMP/FD)
             MONMSG     MSGID(CPF0000)
 
/**********  RCVF                                                     */                 /*DAI103A*/
/**********  MONMSG     MSGID(CPF0000)                                */                 /*DAI103A*/
             OVRDBF     FILE(QAFDBASI) TOFILE(QTEMP/FD)                                  /*DAI103A*/
             RCVF       OPNID(FILEINFO)                                                  /*DAI103A*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))                            /*DAI103A*/
 
             CHGVAR     VAR(&DIR) VALUE('MLREPORTS/' *CAT &BJMRDT)
             CALL       PGM(GPMAKDIR) PARM(&DIR)
 
             IF         COND(&SPLF = 'GPRPTMLCP1'       +
                         *OR &SPLF = 'GPRPTMLPP1'       +
                         *OR &SPLF = 'GPRPTMLIP1'       +
                         *OR &SPLF = 'GPRPTMZBP1')      THEN(DO)
/************CRTPF      FILE(QTEMP/NAD) RCDLEN(136) MAXMBRS(2) ***/  /*NADC02*/
/************CRTPF      FILE(QTEMP/NAD) RCDLEN(149) MAXMBRS(2) ***/  /*NADC02 FRAIMP*/
             CRTPF      FILE(QTEMP/NAD) RCDLEN(162) MAXMBRS(2)       /*FRAIMP*/
             MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&SPLF = 'GPRPTMXCP1'       +
                         *OR &SPLF = 'GPRPTMXPP1'       +
                         *OR &SPLF = 'GPRPTMXIP1'       +
                         *OR &SPLF = 'GPRPTMZIP1')      THEN(DO)
/************CRTPF      FILE(QTEMP/NAD) RCDLEN(250) MAXMBRS(2) ***/  /*NADC02*/
/************CRTPF      FILE(QTEMP/NAD) RCDLEN(265) MAXMBRS(2) ***/  /*NADC02 FRAIMP*/
             CRTPF      FILE(QTEMP/NAD) RCDLEN(280) MAXMBRS(2)       /*FRAIMP*/
             MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&SPLF = 'GPRPTMZCP1'       +
                         *OR &SPLF = 'GPRPTMZPP1'       +
                         *OR &SPLF = 'GPRPTMZSP1')      THEN(DO)
/************CRTPF      FILE(QTEMP/NAD) RCDLEN(352) MAXMBRS(2) ***/  /*NADC02*/
/************CRTPF      FILE(QTEMP/NAD) RCDLEN(382) MAXMBRS(2) ***/  /*NADC02 FRAIMP*/
             CRTPF      FILE(QTEMP/NAD) RCDLEN(412) MAXMBRS(2)       /*FRAIMP*/
             MONMSG     MSGID(CPF0000)
             ENDDO
 
             ADDPFM     FILE(QTEMP/NAD) MBR(NADI)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(&SPLF) TOFILE(QTEMP/NAD) SPLNBR(*LAST) +
                          TOMBR(NADI) CTLCHAR(*PRTCTL)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(NADI) TOFILE(QTEMP/NAD) MBR(NADI)
             OVRDBF     FILE(NAD ) TOFILE(QTEMP/NAD) MBR(NAD )
             CALL       PGM(GPCPYSPIT)
 
             IF         COND(&EXC ¬= 'Y') THEN(DO)
/**********  CHGVAR     VAR(&TOOB) VALUE(&DIR *TCAT '/' *CAT &ATTXT  *TCAT '.TXT') */    /*DAI103A*/
             CHGVAR     VAR(&TOOB) +
                        VALUE(&DIR *TCAT '/' *CAT &FILEINFO_ATTXT  *TCAT '.TXT')         /*DAI103A*/
             ENDDO
             IF         COND(&EXC  = 'Y') THEN(DO)
/**********  CHGVAR  VAR(&TOOB) VALUE(&DIR *TCAT '/' *CAT &ATTXT  *TCAT ' EXCESS.TXT')*/ /*DAI103A*/
             CHGVAR     VAR(&TOOB) +
                        VALUE(&DIR *TCAT '/' *CAT &FILEINFO_ATTXT  *TCAT ' EXCESS.TXT')  /*DAI103A*/
             ENDDO
 
             COPY       OBJ('/QSYS.LIB/QTEMP.LIB/NAD.FILE/NAD.MBR') +
                          TOOBJ(&TOOB) TOCCSID(437) DTAFMT(*TEXT) REPLACE(*YES)
             MONMSG     MSGID(CPF0000)
/**********  ENDPGM                                                  */                  /*DAI103A*/
       END:  ENDPGM
