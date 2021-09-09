/*STD    CLPBASE                                                                             */
             PGM PARM(&B4LIB)
             DCL       VAR(&B4LIB) TYPE(*CHAR) LEN(10)

             CRTSAVF    FILE(&B4LIB/LSDM_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTSAVF    FILE(&B4LIB/LSDTA_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)


             CRTSAVF    FILE(&B4LIB/MSDM_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTSAVF    FILE(&B4LIB/MSDTA_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)

             CRTSAVF    FILE(&B4LIB/PSDM_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTSAVF    FILE(&B4LIB/PSDTA_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)

             CRTSAVF    FILE(&B4LIB/ASDM_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTSAVF    FILE(&B4LIB/ASDTA_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)

             CRTSAVF    FILE(&B4LIB/GSGTA_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)


             CRTSAVF    FILE(&B4LIB/LSDV_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTSAVF    FILE(&B4LIB/MSDV_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTSAVF    FILE(&B4LIB/PSDV_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTSAVF    FILE(&B4LIB/ASDV_0) AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)



/* SAVE   OBJ                         */
             SBMJOB     CMD(SAVOBJ OBJ(MEINCRM1 MEINFTJ1 MEINFTJ2 +
                          MEINFTJ3 MEINFTL0 MEINFTL2 MEINFTL3 +
                          MEINFTL4 MEINMPJ1 MEINMPJ2 MEINMPJ3 +
                          V_MEINFTJ4) LIB(ASDVLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/ASDV_0) OUTPUT(*PRINT)) +
                          JOB(SAV_ASDV) JOBQ(QINTER)

             SBMJOB     CMD(SAVOBJ OBJ(MEINCRM1 MEINFTJ1 MEINFTJ2 +
                          MEINFTJ3 MEINFTL0 MEINFTL2 MEINFTL3 +
                          MEINFTL4 MEINMPJ1 MEINMPJ2 MEINMPJ3 +
                          V_MEINFTJ4) LIB(LSDVLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/LSDV_0) OUTPUT(*PRINT)) +
                          JOB(SAV_LSDV) JOBQ(QINTER)

             SBMJOB     CMD(SAVOBJ OBJ(MEINCRM1 MEINFTJ1 MEINFTJ2 +
                          MEINFTJ3 MEINFTL0 MEINFTL2 MEINFTL3 +
                          MEINFTL4 MEINMPJ1 MEINMPJ2 MEINMPJ3 +
                          V_MEINFTJ4) LIB(PSDVLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/PSDV_0) OUTPUT(*PRINT)) +
                          JOB(SAV_PSDV) JOBQ(QINTER)

             SBMJOB     CMD(SAVOBJ OBJ(MEINCRM1 MEINFTJ1 MEINFTJ2 +
                          MEINFTJ3 MEINFTL0 MEINFTL2 MEINFTL3 +
                          MEINFTL4 MEINMPJ1 MEINMPJ2 MEINMPJ3 +
                          V_MEINFTJ4) LIB(MSDVLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/MSDV_0) OUTPUT(*PRINT)) +
                          JOB(SAV_MSDV) JOBQ(QINTER)


             SAVOBJ     OBJ(MEINFTPD) LIB(LSDMLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/LSDM_0) OUTPUT(*PRINT)


             SAVOBJ     OBJ(MEINFTPD) LIB(PSDMLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/PSDM_0) OUTPUT(*PRINT)


             SAVOBJ     OBJ(MEINFTPD) LIB(MSDMLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/MSDM_0) OUTPUT(*PRINT)


             SAVOBJ     OBJ(CBCMPNPD CBDPRLPD SDMREFPD SCSARDPD +
                          GBXXUSRMSG GBFTUSRMSG GBMEMSG GBSDUSRMSG +
                          GBWNMSGF GBDRSMM SDMTAGPD SFMENUPD) +
                          LIB(LSDTALIB) DEV(*SAVF) +
                          SAVF(&B4LIB/LSDTA_0) OUTPUT(*PRINT)


             SAVOBJ     OBJ(CBCMPNPD CBDPRLPD SDMREFPD SCSARDPD +
                          GBXXUSRMSG GBFTUSRMSG GBMEMSG GBSDUSRMSG +
                          GBWNMSGF GBDRSMM SDMTAGPD SFMENUPD) +
                          LIB(PSDTALIB) DEV(*SAVF) +
                          SAVF(&B4LIB/PSDTA_0) OUTPUT(*PRINT)


             SAVOBJ     OBJ(CBCMPNPD CBDPRLPD SDMREFPD SCSARDPD +
                          GBXXUSRMSG GBFTUSRMSG GBMEMSG GBSDUSRMSG +
                          GBWNMSGF GBDRSMM SDMTAGPD SFMENUPD) +
                          LIB(MSDTALIB) DEV(*SAVF) +
                          SAVF(&B4LIB/MSDTA_0) OUTPUT(*PRINT)


             SBMJOB      CMD(SAVLIB LIB(ASDTALIB) DEV(*SAVF) +
                          SAVF(&B4LIB/ASDTA_0) OUTPUT(*PRINT)) +
                          JOB(SAV_ASDT) JOBQ(QINTER)


             SBMJOB      CMD(SAVLIB LIB(ASDMLIB) DEV(*SAVF) +
                          SAVF(&B4LIB/ASDM_0) OUTPUT(*PRINT)) +
                          JOB(SAV_ASDM) JOBQ(QINTER)


             SAVOBJ     OBJ(GPMTXTPD T_GRMENUG T_GRMENUH T_GRMENUL) +
                          LIB(GSGTALIB) DEV(*SAVF) +
                          SAVF(&B4LIB/GSGTA_0) OUTPUT(*PRINT)



             ENDPGM
