     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas MM UDF purging program')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMDELUDF - Midas UDF purging for MM deals                    *
      *                                                               *
      *  Function:  This program deletes a record from UDF            *
      *             extension tables                                  *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 252554A *CREATE    Date 11Feb09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  252554A - Delete the corresponding record in the UDF files   *
      *            during COB.                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGPZONEL2  IF   E           K DISK

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Data Area for system details
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ** Copyright(c)
     D @CPY            S             80    DIM(7) CTDATA PERRCD(1)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C                   MOVE      #DLNO         #DDDLNO           6

     C                   IF        #API = 'LDNI'
     C                             OR #API = '*ALL'
      *
      ** Delete record from T_GZLDNIEX table
      *
     C/EXEC SQL
     C+ DELETE FROM T_GZLDNIEX
     C+ WHERE DDDLNO = :#DDDLNO AND
     C+ ZONE = :#ZONE
     C/END-EXEC
     C                   ENDIF
     C                   IF        #API = 'NASP'
     C                             OR #API = '*ALL'
      *
      ** Delete record from T_GZNASPEX table
      *
     C/EXEC SQL
     C+ DELETE FROM T_GZNASPEX
     C+ WHERE DDDLNO = :#DDDLNO AND
     C+ ZONE = :#ZONE
     C/END-EXEC
     C                   ENDIF
     C                   IF        #API = 'NASS'
     C                             OR #API = '*ALL'
      *
      ** Delete record from T_GZNASSEX table
      *
     C/EXEC SQL
     C+ DELETE FROM T_GZNASSEX
     C+ WHERE DDDLNO = :#DDDLNO AND
     C+ ZONE = :#ZONE
     C/END-EXEC
     C                   ENDIF
      *
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *Entry        PLIST
     C                   PARM                    #DLNO             6 0
     C                   PARM                    #API              4

      *
      ** Get zone.
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
     C     LIBR          CHAIN     GPZONEL2
     C                   MOVE      ZOZONE        #ZONE            10
     C                   ENDSR
      ********************************************************************
** CPY@
(c) Finastra International Limited 2009
