     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Global Layer Initialise Files')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1125 - Global Layer Initialise Files                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK023 *CREATE     Date 06DEC05               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CPK023 - Midasplus Bridge Changes                            *
      *                                                               *
      *****************************************************************
      *
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *
     FGPUTJSPD  UF A E             DISK
     FGPUTNIPD  UF A E             DISK
     FGPICDTPD  UF A E             DISK
      *
      * +--------------------------------------+
      * ¦ D-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *
     D Recursive       S              1
     D I#LASTSEQ       DS
     D  LastSeqN                     10S 0
     D  gprepn         S              2    DTAARA(GPREPNLOG)
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
      *
     C                   EVAL      Recursive = 'N'
      *
      *
      * Initialise Universal Transaction Jrn Seq No if not set
     C                   EXSR      I_GPUTJSPD
      *
      * Initialise Replication Log Data Area
     C                   EXSR      I_GPREPNLOG
      *
      * Initialise Universal Transaction Next Seq No
     C                   EXSR      I_GPUTNIPD
      *
      * Initialise Global ICD
     C                   EXSR      I_GPICDTPD
      *
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
 
 
      * +-I_GPUTJSPD ----------------------------------------------------+
      * ¦ Initialise Universal Transaction Jrn Seq No if not set         ¦
      * +----------------------------------------------------------------+
     C     I_GPUTJSPD    BEGSR
      *
      *
     C     1             SETLL     GPUTJSPD
     C                   READ(N)   GPUTJSPD                               20
      *
      *
      * If record not found, create it
     C                   IF        *IN20 = *ON
     C                   EVAL      lastseqn = 1
     C                   WRITE     GPUTJSD0
     C                   ELSE
 
      * If record found, check its set
     C                   TESTN                   I#LASTSEQ            21
 
      * Set seqn no if necessary and update
     C                   IF        *in21 = *off or
     C                             %INT(I#LASTSEQ) <= 0
     C     1             SETLL     GPUTJSPD
     C                   READ      GPUTJSPD
     C                   EVAL      lastseqn = 1
     C                   UPDATE    GPUTJSD0
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      * +-I_GPREPNLOG ---------------------------------------------------+
      * ¦ Initialise Replication Log Data Area if not set                ¦
      * +----------------------------------------------------------------+
     C     I_GPREPNLOG   BEGSR
 
 
     C                   IN        gprepn
     C                   IF        gprepn <> 'YN'
     C     *LOCK         IN        gprepn
     C                   EVAL      gprepn = 'YN'
     C                   OUT       gprepn
     C                   ENDIF
 
     C                   ENDSR
      * +-I_GPUTNIPD ----------------------------------------------------+
      * ¦ Initialise Universal Transaction Next Seq No                   ¦
      * +----------------------------------------------------------------+
     C     I_GPUTNIPD    BEGSR
      *
      *
     C     1             SETLL     GPUTNIPD
     C                   READ(N)   GPUTNIPD                               20
      *
      *
      * If record not found, create it
     C                   IF        *IN20 = *ON
     C                   EVAL      idntid = 1
     C                   WRITE     GPUTNID0
     C                   ELSE
 
      * Set seqn no if necessary and update
     C                   IF        idntid <= 0
     C     1             SETLL     GPUTNIPD
     C                   READ      GPUTNIPD
     C                   EVAL      idntid = 1
     C                   UPDATE    GPUTNID0
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      * +-I_GPICDTPD ----------------------------------------------------+
      * ¦ Initialise Global ICD                                          ¦
      * +----------------------------------------------------------------+
     C     I_GPICDTPD    BEGSR
      *
      *
     C     1             SETLL     GPICDTPD
     C                   READ(N)   GPICDTPD                               20
      *
      *
      * If record not found, create it
     C                   IF        *IN20 = *ON
     C                   EVAL      glsnam = 'Global Midas'
     C                   WRITE     GPICDTD0
     C                   ELSE
 
      * Set system name if necessary and update
     C                   IF        glsnam <> 'Global Midas'
     C     1             SETLL     GPICDTPD
     C                   READ      GPICDTPD
     C                   EVAL      glsnam = 'Global Midas'
     C                   UPDATE    GPICDTD0
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
