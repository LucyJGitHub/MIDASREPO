/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FBM2.1SP21                           */
/*                                                                   */
/*********************************************************************/
/*      OMITEND                                                      */
QCMDEXC:
             IF         COND(&EML108 *EQ 'Y') THEN(CALL +
                            PGM(QCMDEXC) PARM(&OPQF 1500))
             ELSE       CMD(DO)
                        CALL       PGM(QCMDEXC) PARM(&OPQF 1000)
                        ENDDO
/**/
 CHECK:      IF         COND(&EML108 *EQ 'Y') THEN(DO)
             IF         COND(&ABTYP *NE 'Y' *AND &DBTYP *NE 'Y') +
                          THEN(CPYFRMQRYF FROMOPNID(ACCNTAB) +
                          TOFILE(MCBLRPX0) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK))
             ENDDO

