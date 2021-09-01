/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('DOWNLOAD LOAN IQ DATA TO xxERDLIB')                  */
/********************************************************************/
/*                                                                  */
/*     Midas - European Reporting - Italy                           */
/*                                                                  */
/*     ERC0690LIQ - DOWNLOAD LOAN IQ DATA TO xxERDLIB               */
/*                                                                  */
/*     (C) Copyright Misys 2008                                     */
/*                                                                  */
/*     Last Amend No. MD058100           Date 20May21               */
/*     Prev Amend No. LUC139   *Amend    Date 27Jan21               */
/*                    LUC139             Date 04Jan21               */
/*                    MBV006   *Create   Date 06Jun08               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD058100 - Rollup of additional BoI onsite fixes at FbMidas*/
/*       LUC139 - Make CPYF for in house *NOCHK                     */
/*       LUC139 - Upgrade UCI Italian Returns                       */
/*       MBV006 - Extract Loan IQ transactions                      */
/*                                                                  */
/********************************************************************/

             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')     /*S01189*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

             CHGJOB     SWS(00000000)

             SNDMSG     MSG('ERC0690LIQ - Download Loan IQ Data to +
                          xxERDLIB') TOMSGQ(MRUNQ)

/* Retrieve Midas sbs prefix and build library names                 */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&ERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')
             CHGVAR     VAR(&DILIB) VALUE(&PREFIX *CAT 'DILIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')

/*   Call PGM CB0160 to find out if this is a Restart                */

             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)

/* If this is a restart, restore xxERDLIB from copy taken at the     */
/* end of the previous component (ERC0600LIQ)                        */

             IF         COND(&BUSY *EQ 'Y') THEN(DO)
             RSTLIB     SAVLIB(&ERDLIB) DEV(*SAVF) SAVF(&DILIB/ERSAVF1)
             RSTOBJ     OBJ(EREXTRPD) SAVLIB(&DPLIB) DEV(*SAVF) +
                          SAVF(&DILIB/ERC0600LIQ)
             ENDDO

/*   Set restart indicator to 'Y'                                    */

             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)

/* Download Loan IQ data to xxERDLIB                                 */

             CPYF       FROMFILE(BVEREXTRPD) +
                          TOFILE(&ERDLIB/EREXTRPD) MBROPT(*ADD)  FMTOPT(*nochk    )

             CPYF       FROMFILE(BVCLOANCL) TOFILE(&ERDLIB/CLOANCL ) +
                          MBROPT(*ADD) FMTOPT(*nochk    )

/*******     CPYF       FROMFILE(BVCLOANKXP) +                                               ******/
/*******                  TOFILE(&ERDLIB/CLOANKXP) MBROPT(*replace)                          ******/

             CPYF       FROMFILE(BVHISTSHM) TOFILE(&ERDLIB/HISTSHM) +
                          MBROPT(*ADD) FMTOPT(*nochk    )

             CPYF       FROMFILE(BVHISTSHP) TOFILE(&ERDLIB/HISTSHP) +
                          MBROPT(*ADD) INCCHAR(GPRT 1 *NE '*') +
                          FMTOPT(*nochk    )

             CPYF       FROMFILE(BVHISTSHQ) TOFILE(&ERDLIB/HISTSHQ) +
                          MBROPT(*ADD) FMTOPT(*nochk    )

             CPYF       FROMFILE(BVERLVENPD) +
                          TOFILE(&ERDLIB/ERLVENPD) MBROPT(*ADD) FMTOPT(*nochk    )

             CPYF       FROMFILE(BVFCLTYFM) TOFILE(&ERDLIB/FCLTYFM) +
                          MBROPT(*ADD) FMTOPT(*nochk    )

/*********** CPYF       FROMFILE(BVFCLTYFXP) +                                                *****/
/***********              TOFILE(&ERDLIB/FCLTYFXP) MBROPT(*replace) FMTOPT(*nochk    )        *****/

/*********** CPYF       FROMFILE(BVGTEESGT) TOFILE(&ERDLIB/GTEESGT) +                         *****/
/***********              MBROPT(*ADD) FMTOPT(*nochk    )                                     *****/

/*********** CPYF       FROMFILE(BVGTEESGXP) +                                                *****/
/***********              TOFILE(&ERDLIB/LEGTT1PD) MBROPT(*ADD) FMTOPT(*nochk    )            *****/

             CPYF       FROMFILE(BVLQLKPF) +
                          TOFILE(&ERDLIB/BVLQLKPF) MBROPT(*REPLACE) FMTOPT(*nochk    )
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/BVLQLKPF))
/* Update files in zzERDLIB */
             ADDLIBLE   LIB(&ERDLIB)
/*  BVCLOANKXP  ->  LECLT1PD */
             CALL       PGM(UTLUC139J)
/*  BVFCLTYFXP  ->  LEFCT1L0 */
             CALL       PGM(UTLUC139K)
/*  BVGTEESGXP  ->  LEGTT1PD */
             CALL       PGM(UTLUC139L)
/*  BVGTEESGT   ->  GTEESGT  */
             CALL       PGM(UTLUC139M)
/*   Set restart indicator to 'N'                                    */

/*********** CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')                                 *********/

             GOTO       CMDLBL(EOJ)

 ERROR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('ERC0690LIQ terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)

EOJ:
             ENDPGM
