     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update and check SMNEWZPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000020 - Update and check SMNEWZPD                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSM006  *CREATE    Date 22Mar05               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSM006 - Create new zone based on existing zone.             *
      *                                                               *
      *****************************************************************
      *
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *
     FSMNEWZPD  UF A E             DISK
      *
     D Recursive       S              1
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              7
     C                   PARM                    StatusPosition    2 0
     C                   PARM                    Status            1
     C                   PARM                    NewZone           2
     C                   PARM                    GlobalLayer       2
     C                   PARM                    BasedOnZone       2
     C                   PARM                    Zone             10
     C                   PARM                    ZoneCode          4
     C                   PARM                    ZoneDesc         50
      *
     C                   EVAL      Recursive = 'N'
      *
     C                   SELECT
      *
     C                   WHEN      Mode = '*UPDDTA'
     C                   EVAL      NZNZPX = NewZone
     C                   EVAL      NZGLPX = GlobalLayer
     C                   EVAL      NZBOPX = BasedOnZone
     C                   EVAL      NZZONE = Zone
     C                   EVAL      NZZNCD = ZoneCode
     C                   EVAL      NZZNDS = ZoneDesc
     C                   EVAL      NZCSTS = *blanks
     C                   WRITE     SMNEWZD0
      *
     C                   WHEN      Mode = '*CHKSTS'
     C     1             SETLL     SMNEWZPD
     C                   READ      SMNEWZPD
     C                   EVAL      Status = %SUBST(NZCSTS:StatusPosition:1)
      *
     C                   WHEN      Mode = '*UPDSTS'
     C     1             SETLL     SMNEWZPD
     C                   READ      SMNEWZPD
     C                   EVAL      %SUBST(NZCSTS:StatusPosition:1) = Status
     C                   UPDATE    SMNEWZD0
      *
     C                   ENDSL
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
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
