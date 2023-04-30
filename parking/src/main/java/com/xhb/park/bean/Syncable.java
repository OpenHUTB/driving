package com.xhb.park.bean;

/**
 * 是否允许给厂端下发
 */
public interface Syncable {

    /**
     * 获取车厂id
     *
     * @return
     */
    Long getParkId();

    /**
     * 设置同步状态
     *
     * @param isSync 1 同步 0 未同步
     */
    void setIsSync(Integer isSync);

    default Integer getVersion() {
        return 0;
    }

    default void setVersion(Integer version) {

    }

    /**
     * 获取主键值
     *
     * @return
     */
    Long getPrimaryVal();

    /**
     * 设置id
     */
    void setId(Long id);
}
